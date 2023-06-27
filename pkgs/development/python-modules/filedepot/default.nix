{ lib
, anyascii
, importlib-metadata
, fetchFromGitHub
, buildPythonPackage
, urllib3
, pythonOlder
, sqlalchemy
, webtest
, pillow
, coverage
, boto
, flaky
, boto3
, mock
, pymongo
}:

buildPythonPackage rec {
  pname = "filedepot";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "depot";
    rev = "refs/tags/${version}";
    hash = "sha256-OJc4Qwar3sKhKKF1WldwaueRG7FCboWT2wXYldHJbPU=";
  };

  patchPhase = ''
    sed -i '/TurboGears2/d' setup.py
    sed -i '/ming/d' setup.py
    rm -f tests/test_fields_ming.py
    rm -f tests/base_ming.py
    rm -f tests/test_wsgi_middleware.py
    rm -f depot/fields/ming.py
  '';

  propagatedBuildInputs = [
    anyascii
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

  nativeCheckInputs = [
    sqlalchemy
    webtest
    pillow
    coverage
    boto
    flaky
    boto3
    mock
    pymongo
  ];

  checkPhase = ''
    coverage run --source depot -m unittest discover -v
  '';

  meta = with lib; {
    homepage = "https://github.com/amol-/depot";
    description = "DEPOT is a framework for easily storing and serving files in web applications on Python2.6+ and Python3.2+.";
    longDescription = ''
      DEPOT supports storing files in multiple backends, like:

      Local Disk
      In Memory (for tests)
      On GridFS
      On Amazon S3 (or compatible services)
      On Google Cloud Storage
      and integrates with database by providing files attached to your SQLAlchemy or Ming/MongoDB models with respect to transactions behaviours (files are rolled back too).
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ faradaydevel ];
  };
}

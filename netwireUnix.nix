{
  buildDunePackage,
  pname,
  version,
  netwire,
}:
buildDunePackage {
  inherit pname version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  propagatedBuildInputs = [ netwire ];

  doCheck = true;
}

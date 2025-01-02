{
  buildDunePackage,
  version,
  netwire,
}:
buildDunePackage {
  pname = "netwireUnix";
  inherit version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  propagatedBuildInputs = [ netwire ];

  doCheck = true;
}

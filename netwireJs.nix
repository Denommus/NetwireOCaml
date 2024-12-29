{
  buildDunePackage,
  pname,
  version,
  melange,
  netwire,
}:
buildDunePackage {
  inherit pname version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  propagatedBuildInputs = [ netwire melange ];

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

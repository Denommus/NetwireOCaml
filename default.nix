{
  buildDunePackage,
  pname,
  version,
  melange,
}:
buildDunePackage {
  inherit pname version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

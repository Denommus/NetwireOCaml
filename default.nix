{
  buildDunePackage,
  melange,
  pname,
}:
buildDunePackage {
  inherit pname;
  version = "0.1";

  duneVersion = "3";

  src = ./.;

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

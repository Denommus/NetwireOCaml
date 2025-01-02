{
  buildDunePackage,
  version,
  melange,
}:
buildDunePackage {
  pname = "netwire";
  inherit version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

{
  buildDunePackage,
  version,
  melange,
}:
buildDunePackage {
  pname = "netwire";
  inherit version;

  src = ./.;

  minimalOCamlVersion = "5.2";

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

{
  buildDunePackage,
  version,
  melange,
  netwire,
}:
buildDunePackage {
  pname = "netwireJs";
  inherit version;

  src = ./.;

  minimalOCamlVersion = "5.0";

  propagatedBuildInputs = [ netwire melange ];

  nativeBuildInputs = [ melange ];

  doCheck = true;
}

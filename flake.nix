{
  description = "An AFRP library based on Netwire";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pname = "netwire";
        overlay = (
          final: prev: {
            "${pname}" = final.ocamlPackages.callPackage ./. { inherit pname; };
            netwireTime = final.ocamlPackages.callPackage ./netwireTime.nix { pname = "netwireTime"; };
          }
        );
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlay
          ];
        };
      in
      {
        packages = {
          default = pkgs."${pname}";
          "${pname}" = pkgs."${pname}";
          netwireTime = pkgs.netwireTime;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            pkgs."${pname}"
          ];
          buildInputs = [
            pkgs.ocamlPackages.ocaml-lsp
            pkgs.ocamlPackages.utop
            pkgs.ocamlPackages.ocamlformat
            pkgs.ocamlPackages.ocaml-print-intf
          ];
        };
      }
    );

}

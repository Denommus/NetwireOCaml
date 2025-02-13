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
        version = "0.1";
        overlay = (
          final: prev: {
            ocamlPackages = prev.ocamlPackages.overrideScope (
              ofinal: oprev: {
                netwire = final.ocamlPackages.callPackage ./. { inherit version; };
                netwireUnix = final.ocamlPackages.callPackage ./netwireUnix.nix {
                  inherit version;
                };
                netwireJs = final.ocamlPackages.callPackage ./netwireJs.nix {
                  inherit version;
                };
              }
            );
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
          default = pkgs.ocamlPackages.netwire;
          inherit (pkgs.ocamlPackages) netwire netwireJs netwireUnix;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            pkgs.ocamlPackages.netwire
          ];
          buildInputs = [
            pkgs.ocamlPackages.ocaml-lsp
            pkgs.ocamlPackages.utop
            pkgs.ocamlPackages.ocamlformat
            pkgs.ocamlPackages.ocaml-print-intf
            pkgs.opam
          ];
        };
      }
    );

}

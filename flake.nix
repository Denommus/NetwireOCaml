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
        dune_src =
          prev:
          prev.fetchFromGitHub {
            owner = "ocaml";
            repo = "dune";
            rev = "34de4d1264240f2bddeda4128a2bd285488341ab";
            hash = "sha256-kO9nwa0RrOZvpLvISuqyRDl+g1sJ7IGnpbF0el+MCn8=";
          };
        overlay = (
          final: prev: {
            dune_3 = prev.dune_3.overrideAttrs (old: {
              src = dune_src prev;
            });
            ocamlPackages = prev.ocamlPackages.overrideScope (
              ofinal: oprev: {
                netwire = final.ocamlPackages.callPackage ./. { inherit version; };
                netwireUnix = final.ocamlPackages.callPackage ./netwireUnix.nix {
                  inherit version;
                };
                netwireJs = final.ocamlPackages.callPackage ./netwireJs.nix {
                  inherit version;
                };
                dune_3 = oprev.dune_3.overrideAttrs (old: {
                  src = dune_src prev;
                });
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

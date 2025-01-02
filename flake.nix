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
        pnameUnix = "netwireUnix";
        pnameJs = "netwireJs";
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
            "${pname}" = final.ocamlPackages.callPackage ./. { inherit pname version; };
            "${pnameUnix}" = final.ocamlPackages.callPackage ./netwireUnix.nix {
              pname = pnameUnix;
              inherit version;
            };
            "${pnameJs}" = final.ocamlPackages.callPackage ./netwireJs.nix {
              pname = pnameJs;
              inherit version;
            };
            dune_3 = prev.dune_3.overrideAttrs (old: {
              src = dune_src prev;
            });
            ocamlPackages = prev.ocamlPackages.overrideScope (
              ofinal: oprev: {
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
          default = pkgs."${pname}";
          "${pname}" = pkgs."${pname}";
          "${pnameUnix}" = pkgs."${pnameUnix}";
          "${pnameJs}" = pkgs."${pnameJs}";
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

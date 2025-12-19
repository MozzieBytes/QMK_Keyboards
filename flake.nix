{
  description = "QMK Keyboard Configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-global = {
      url = "github:MozzieBytes/nix-global";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
    nix-global,
    ...
    }:
    nix-global.lib.mkDevEnv { } (
      pkgs: corePkgs:
      let
        qmk-src = pkgs.fetchFromGitHub {
          owner = "qmk";
          repo = "qmk_firmware";
          tag = "0.31.1";
          sha256 = "sha256-jibfaqh4uTx2sWyQ9V5qiUoe9B+8jK3g1WXNfs2xArg=";
          fetchSubmodules = true;
        };
        compile = pkgs.callPackage ./utils/qmk-compile.nix { inherit qmk-src; };
      in
        rec {
        packages = {
          gmmk_pro = compile {
            name = "gmmk_pro";
            config = ./keyboards/gmmk_pro.json;
            ext = "bin";
          };
          corne = compile {
            name = "corne";
            config = ./keyboards/corne.json;
            ext = "uf2";
            is_rp2040 = true;
          };
        };
        apps = pkgs.lib.mapAttrs (name: fw: {
          type = "app";
          program = "${pkgs.writeScript "flash-${name}" ''
            #!/usr/bin/env bash
            set -euo pipefail

            export QMK_HOME="${qmk-src}"

            qmk flash ${fw}
          ''}";
        }) packages;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.qmk
            pkgs.dos2unix
          ]
            ++ corePkgs;
          shellHook = ''
            export QMK_HOME="${qmk-src}"
          '';
        };
      }
    );
}

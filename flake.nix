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
        mkQmkFw = pkgs.callPackage ./utils/mkQmkFw.nix { inherit qmk-src; };
        mkFlashApps = pkgs.callPackage ./utils/mkFlashApps.nix { inherit qmk-src; };
      in
      rec {
        packages = mkQmkFw {
          gmmk_pro = {
            ext = "bin";
          };
          corne = {
            ext = "uf2";
            is_rp2040 = true;
          };
        };
        apps = mkFlashApps packages;
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

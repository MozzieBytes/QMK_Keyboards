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
        qmk = pkgs.callPackage ./modules/qmk.nix { inherit qmk-src; };
      in
      {
        packages = with qmk; {
          gmmk_pro = {
            compile = compile {
              name = "gmmk_pro";
              config = ./keyboards/gmmk_pro.json;
            };
            flash = flash {
              fw = gmmk_pro.compile;
              ext = "bin";
            };
          };
          corne = {
            compile = compile {
              name = "corne";
              config = ./keyboards/corne.json;
              is_rp2040 = true;
            };
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = corePkgs;
        };
      }
    );
}

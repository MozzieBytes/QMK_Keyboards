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
        qmk = pkgs.callPackage ./utils/qmk.nix { inherit qmk-src; };
      in
      {
        packages.compile = with qmk; {
          gmmk_pro = compile {
            name = "gmmk_pro";
            config = ./keyboards/GMMK_Pro/gmmk_pro_rev1_ansi.json;
          };
          corne = compile {
            name = "corne";
            config = ./keyboards/Corne/crkbd_rev1.json;
            is_rp2040 = true;
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              qmk
              dos2unix
            ]
            ++ corePkgs;
          shellHook = ''
            export QMK_HOME=$PWD/qmk-home
            mkdir -p $QMK_HOME
            if [ ! -e "$QMK_HOME/qmk_firmware" ]; then
              ln -s ${qmk-src} "$QMK_HOME/qmk_firmware"
            fi
            [ -d "$QMK_HOME/qmk_firmware/.git/modules" ] || qmk setup -y
          '';
        };
      }
    );
}

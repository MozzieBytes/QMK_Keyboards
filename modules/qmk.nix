{
  pkgs,
  lib,
  stdenv,
  qmk-src,
}:
let
  fwExtensions = [
    "hex"
    "bin"
    "elf"
    "dfu"
    "uf2"
    "eep"
  ];
in
{
  compile =
    {
      name,
      config,
      is_rp2040 ? false,
    }:
    let
      buildDir = "build";
    in
    stdenv.mkDerivation {
      inherit name;
      src = qmk-src;
      buildInputs = with pkgs; [
        qmk
      ];
      buildPhase = ''
        qmk compile \
          --env SKIP_GIT=true \
          --env BUILD_DIR=${buildDir} \
          ${lib.optionalString (is_rp2040) "--env CONVERT_TO=rp2040_ce"} \
          ${config}
      '';
      installPhase = ''
        mkdir -p $out
        cp ${buildDir}/*.{${lib.strings.concatStringsSep "," fwExtensions}} $out
      '';
      dontFixup = true;
    };
  flash =
    {
      fw,
      ext,
    }:
    assert lib.elem ext fwExtensions;
    pkgs.writeShellApplication {
      name = "flash-qmk";
      runtimeInputs = with pkgs; [ qmk dos2unix ];
      text = ''
        set -quo pipefail

        FW_DIR="${fw}"
        FW_FILE="$FW_DIR/*.${ext}"

        if [[ ! -f "$FW_FILE" ]]; then
          echo "No *.${ext} file found in $FW_DIR" >&2
          ls -la "$FW_DIR" >&2
          exit 1
        fi

        echo "Flashing $FW_FILE"
        qmk flash "$FW_FILE"
      '';
    };
}

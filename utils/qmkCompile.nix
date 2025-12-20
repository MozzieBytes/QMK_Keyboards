{
  pkgs,
  lib,
  qmk-src,
  stdenv,
  name,
  config,
  ext,
  is_rp2040 ? false,
}:
let
  supportedExtensions = [
    "hex"
    "bin"
    "elf"
    "dfu"
    "uf2"
    "eep"
  ];
  suppExtStr = lib.concatStringsSep ", " supportedExtensions;
  buildDir = "build";
in
  if !lib.elem ext supportedExtensions then
  throw "Invalid QMK firmware extension '${ext}' for ${name}. (${suppExtStr})"
else
  stdenv.mkDerivation {
    name = "${name}.${ext}";
    src = qmk-src;
    buildInputs = with pkgs; [
      qmk
      dos2unix
    ];
    buildPhase = ''
          qmk compile \
            --env SKIP_GIT=true \
            --env BUILD_DIR=${buildDir} \
      ${lib.optionalString (is_rp2040) "--env CONVERT_TO=rp2040_ce"} \
      ${config}
    '';
    installPhase = ''
          cp ${buildDir}/*.${ext} $out
    '';
    dontFixup = true;
  }

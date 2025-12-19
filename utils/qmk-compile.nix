{
  pkgs,
  lib,
  stdenv,
  qmk-src,
}:
{
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
  buildDir = "build";
in
assert lib.elem ext supportedExtensions;
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

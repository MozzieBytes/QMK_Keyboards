{
  pkgs,
  lib,
  stdenv,
  qmk-src,
}:
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
        cp ${buildDir}/*.{hex,bin,elf,dfu,uf2,eep} $out
      '';
      dontFixup = true;
    };
}

{
  pkgs,
  lib,
  stdenv,
  qmk-src,
}:
pkgs.lib.mapAttrs (
  name: attrs:
  import ./qmkCompile.nix (
    attrs
    // {
      inherit pkgs lib stdenv qmk-src name;
      config = ../keyboards/${name}.json;
    }
  )
)

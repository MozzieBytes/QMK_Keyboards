{
  pkgs,
  lib,
  stdenv,
  qmk-src,
  qmkCompile ? import ./qmkCompile.nix
}:
pkgs.lib.mapAttrs (
  name: attrs:
  qmkCompile (
    attrs
    // {
      inherit pkgs lib stdenv qmk-src name;
      config = ../configs/${name}.json;
    }
  )
)

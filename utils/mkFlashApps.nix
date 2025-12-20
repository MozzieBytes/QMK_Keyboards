{
  pkgs,
  lib,
  qmk-src,
}:
lib.mapAttrs (
  name: fw: {
    type = "app";
    program = "${pkgs.writeScript "flash-${name}" ''
      #!/usr/bin/env bash
      set -euo pipefail

      export QMK_HOME="${qmk-src}"

      ${pkgs.qmk}/bin/qmk flash ${fw}
    ''}";
  }
)

# QMK_Keyboards
Github repo with QMK Keyboard Configurations

## TODO - Flake Migration
I Need to follow the approach established within [nixcaps](https://github.com/agustinmista/nixcaps?tab=readme-ov-file), and pull the qmk firmware directly from source.

I would use the engineer's current implementation, but it does not work with JSON configs

My end goal would be the following:
 - Nix Build compiles the firmware
 - Nix Run flashes it.

Though a single process where run builds and flashes the firmware would not be a bad implementation


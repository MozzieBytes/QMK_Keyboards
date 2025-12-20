# QMK_Keyboards

Nix project for the management of my personal QMK Configs.

## Inspiration

In [May 2025](https://github.com/qmk/qmk_firmware/commit/04b26d93b11a77e7beb81da50b34f5f38c94e71a#diff-4908a6bfd166677f6f0d18dcd79a23231e01834bf19cb4e0656fdeb88d74b4d9), the QMK Project removed the in-tree nix support which had been enabling me to build my QMK firmware without having QMK permanently configured on my machines. 

This fundamental change meant that I needed to find a new method for building my firmware.

Investigation brought up [nixcaps](https://github.com/agustinmista/nixcaps/tree/main), but this implementation assumes you're using QMK's traditional 'C' configuration files.

In my usecase, my firmware configurations are sourced from the online QMK Configurator. 

I have therefore been pushed to establish my own solution using nixcaps as inspiration.

## Usage

### DevShell

This project utilizes a nix devShell to create a dev environment with the QMK cli pre-configured using a clone of [qmk-firmware]() that is kept in the nix store. 

This allows us to interact with a read-only instance of the QMK codebase for basic QMK Interactions. 

We do not need to go further than this shell environment as it allows you to compile and flash any in-tree firmware, but for personal preference I want my keyboards as flake outputs.

### Keyboard Flake Outputs

Each keyboard has flake outputs with two usecases:

| Command | Description |
|:-------:|:------------|
| `nix build .#keyboard` | Compiles the chosen keyboard configuration into a valid QMK Firmware binary. |
| `nix run .#keyboard` | Compiles and Flashes the chosen keyboard firmware onto a QMK-Compatible microcontroller. |

## Adding new keyboards

To add a new keyboard, you need to make two changes

 - Add your exported config from the [qmk web configurator](https://config.qmk.fm) to the `configs` folder.
 - Update the inputs to `mkQmkFw` in `flake.nix` to have your new keyboard as shown in the example.

> [!IMPORTANT]
> `keyboard.json` file names should match the name of the configuration added to the inputs for `mkQmkFw` in `flake.nix`.

### Configuration Schema

| Attribute | Required | Description |
|:---------:|:--------:|:------------|
| `ext` | ✅ | The desired file-extension for the compiled firmware file (hex, bin, elf, dfu, uf2, eep) |
| `is_rp2040` | ❌ | Some of my keyboards utilize rp2040 microcontrollers. This flag signals to the flake that it should convert the fw file during build. |

### Example

```nix
# ...
        packages = mkQmkFw {
          # ...
          keyboard = {
            ext = "bin";
            is_rp2040 = true;
          };
        };
```

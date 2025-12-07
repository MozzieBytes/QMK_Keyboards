{
  description = "QMK Keyboard Configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-global = {
      url = "github:MozzieBytes/nix-global";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nix-global,
    ...
    }: nix-global.lib.mkDevEnv {} (
      pkgs: corePkgs:
      {
        devShells.default = pkgs.mkShell {
          buildInputs = corePkgs;
        };
      }
    );
}

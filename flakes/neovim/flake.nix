{
  description = "Rika's Neovim - standalone mnw wrapped configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      self,
      systems,
      mnw,
      ...
    }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        { system, ... }:
        {
          packages = {
            dev = self.packages.${system}.default.devMode;
            default = import ./package.nix {
              inherit mnw;
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            };
          };
        };
    };
}

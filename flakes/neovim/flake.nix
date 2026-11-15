{
  description = "Rika's Neovim - standalone mnw wrapped configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      mnw,
      systems,
    }:
    {
      packages = nixpkgs.lib.genAttrs (import systems) (system: {
        dev = self.packages.${system}.default.devMode;
        default = import ./package.nix {
          inherit mnw;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
      });
    };
}

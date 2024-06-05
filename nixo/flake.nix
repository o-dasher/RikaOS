{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      inherit (import ./config/myconfig.nix) rika;
    in
    {
      homeConfigurations.${rika.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ./home/home.nix ];
      };

      nixosConfigurations.${rika.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./system/configuration.nix ];
      };
    };
}

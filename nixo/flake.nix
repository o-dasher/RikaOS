{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      cfg = import ./config/myconfig.nix;
      passed_inputs = {
        inherit inputs;
      };
    in
    {
      homeConfigurations.${cfg.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        extraSpecialArgs = passed_inputs;
        modules = [
          ./home/home.nix
          stylix.homeManagerModules.stylix
        ];
      };

      nixosConfigurations.${cfg.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = passed_inputs;
        modules = [
          ./system/configuration.nix
          stylix.nixosModules.stylix
        ];
      };
    };
}

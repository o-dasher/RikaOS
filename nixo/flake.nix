{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-compat.follows = "flake-compat";
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
      inherit (import ./config/myconfig.nix) username hostName;
      define_hm =
        base:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeManagerModules.stylix
            ./config/setconfig.nix
          ] ++ base;
          extraSpecialArgs = {
            inherit inputs;
            utils = import ./home/rika/utils;
          };
        };
    in
    {
      # Personal
      homeConfigurations."${username}@${hostName}" = define_hm [ ./home/satoko ];
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        modules = [ ./system/configuration.nix ];
      };

      # Research lab
      homeConfigurations."${username}@fedora" = define_hm [ ./home/hanyuu ];
      homeConfigurations."${username}@gotec-MS-7D18" = define_hm [ ./home/hanyuu ];
      homeConfigurations."${username}@gotec" = define_hm [ ./home/hanyuu ];
    };
}

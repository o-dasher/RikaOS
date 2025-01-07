{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
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
    hyprland.url = "github:hyprwm/Hyprland";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      lanzaboote,
      ...
    }@inputs:
    let
      inherit (import ./config/myconfig.nix) username hostName;
      define_hm =
        profile:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeManagerModules.stylix
            ./config/setconfig.nix
          ] ++ [ ./home/profiles/${profile} ];
          extraSpecialArgs = {
            inherit inputs;
            utils = import ./home/utils;
          };
        };
    in
    {
      # Personal
      homeConfigurations."${username}@${hostName}" = define_hm "satoko";
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./system/configuration.nix
        ];
      };
    };
}

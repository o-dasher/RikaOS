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
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      lanzaboote,
      ghostty,
      ...
    }@inputs:
    let
      define_hm =
        profile: cfg:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeManagerModules.stylix
          ] ++ [ ./home/profiles/${profile} ];
          extraSpecialArgs = {
            inherit inputs;
            ghostty = ghostty;
            utils = import ./home/utils;
            cfg = import cfg;
          };
        };

      define_system =
        modules: cfg:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            cfg = import cfg;
          };
          modules = modules;
        };

      inherit (import ./system/home/settings.nix) username hostName;
    in
    {
      # Personal
      homeConfigurations."${username}@${hostName}" = define_hm "satoko" ./system/home/settings.nix;
      nixosConfigurations.${hostName} = define_system [
        lanzaboote.nixosModules.lanzaboote
        ./system/home/configuration.nix
      ] ./system/home/settings.nix;
    };
}

{
  description = "RikaOS";

  # Optional step. Binary cache to improve the build time
  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
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
        path:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            cfg = import ./${path}/settings.nix;
          };
          modules = [
            ./${path}/configuration.nix
          ];
        };

      home-cfg = import ./system/home/settings.nix;
      home-server-cfg = import ./system/homeserver/settings.nix;
    in
    {
      # Personal
      nixosConfigurations.${home-cfg.hostName} = define_system "system/home";
      homeConfigurations."${home-cfg.username}@${home-cfg.hostName}" =
        define_hm "satoko" ./system/home/settings.nix;

      # Home server
      nixosConfigurations.${home-server-cfg.hostName} = define_system "system/homeserver";
    };
}

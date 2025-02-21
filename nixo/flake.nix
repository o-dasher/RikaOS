{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        git-hooks.follows = "git-hooks";
        home-manager.follows = "home-manager";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        pre-commit-hooks-nix.follows = "git-hooks";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs-unstable.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        cfg: profile:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            stylix.homeManagerModules.stylix
            ./system/${cfg.hostName}/profiles/${profile}
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit ghostty;
            utils = import ./home/utils;
            cfg = cfg // {
              username = profile;
            };
          };
        };

      define_system =
        cfg:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit cfg;
          };
          modules = [
            stylix.nixosModules.stylix
            ./system/modules
            ./system/${cfg.hostName}/configuration.nix
          ];
        };

      hinamizawa = {
        hostName = "hinamizawa";
        state = "24.05";
        profiles = {
          rika = "rika";
        };
      };

      gensokyo = {
        hostName = "gensokyo";
        state = "24.05";
        profiles = {
          nue = "thiago";
        };
      };
    in
    {
      # Personal
      nixosConfigurations.${hinamizawa.hostName} = define_system hinamizawa;
      homeConfigurations."${hinamizawa.profiles.rika}@${hinamizawa.hostName}" =
        define_hm hinamizawa hinamizawa.profiles.rika;

      # Home server
      nixosConfigurations.${gensokyo.hostName} = define_system gensokyo;
    };
}

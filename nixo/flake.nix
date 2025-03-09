{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs";
    nixpkgs-hydra.url = "github:HeitorAugustoLN/nixpkgs/hydralauncher";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    nix-gaming.url = "github:fufexan/nix-gaming";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        pre-commit-hooks.follows = "git-hooks";
        systems.follows = "systems";
      };
    };
    RikaOS-private = {
      type = "git";
      url = "git@github.com:o-dasher/RikaOS-private.git";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-hydra,
      home-manager,
      stylix,
      ghostty,
      RikaOS-private,
      ...
    }@inputs:
    let
      define_hm =
        cfg: username:
        let
          system = "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            stylix.homeManagerModules.stylix
            ./home/modules
            ./system/${cfg.targetHostName}/profiles/${username}
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit RikaOS-private;
            nixpkgs-hydra = import nixpkgs-hydra { inherit system; };
            utils = import ./home/utils {
              lib = nixpkgs.lib;
              config = self.homeConfigurations.${username}.config;
            };
            cfg = cfg // {
              inherit username;
            };
          };
        };

      define_system =
        cfg:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit RikaOS-private;
            inherit inputs;
            inherit cfg;
          };
          modules = [
            stylix.nixosModules.stylix
            ./system/modules
            ./system/${cfg.targetHostName}/configuration.nix
          ];
        };

      hinamizawa = {
        targetHostName = "hinamizawa";
        hostName = "hinamizawa";
        state = "24.11";
        profiles = {
          rika = "rika";
          satoko = "satoko";
        };
      };

      gensokyo = {
        targetHostName = "gensokyo";
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
      homeConfigurations."${hinamizawa.profiles.satoko}@${hinamizawa.hostName}" =
        define_hm hinamizawa hinamizawa.profiles.satoko;
      homeConfigurations.${hinamizawa.profiles.rika} = define_hm hinamizawa hinamizawa.profiles.rika;

      # Home server
      nixosConfigurations.${gensokyo.hostName} = define_system gensokyo;
      homeConfigurations."${gensokyo.profiles.nue}@${gensokyo.hostName}" =
        define_hm gensokyo gensokyo.profiles.nue;
    };
}

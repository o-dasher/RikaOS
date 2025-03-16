{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/master";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      "https://ghostty.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      nixpkgs-bleeding,
      RikaOS-private,
      mnw,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      define_hm =
        cfg: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          modules = [
            stylix.homeManagerModules.stylix
            mnw.homeManagerModules.mnw
            ./home/modules
            ./system/${cfg.targetHostName}/profiles/${username}
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit RikaOS-private;
            pkgs-bleeding = import nixpkgs-bleeding { inherit system; };
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
          inherit system;
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

      hinamizawa = rec {
        targetHostName = "hinamizawa";
        hostName = targetHostName;
        state = "24.11";
        profiles = {
          rika = "rika";
          satoko = "satoko";
        };
      };

      gensokyo = rec {
        targetHostName = "gensokyo";
        hostName = targetHostName;
        state = "24.05";
        profiles = {
          nue = "thiago";
        };
      };

      grandline = rec {
        targetHostName = "grandline";
        hostName = targetHostName;
        state = "24.05";
        profiles = {
          zoro = "zoro";
        };
      };
    in
    {
      # Personal
      nixosConfigurations.${hinamizawa.hostName} = define_system hinamizawa;
      homeConfigurations.${hinamizawa.profiles.satoko} = define_hm hinamizawa hinamizawa.profiles.satoko;
      homeConfigurations.${hinamizawa.profiles.rika} = define_hm hinamizawa hinamizawa.profiles.rika;

      # Home server
      nixosConfigurations.${gensokyo.hostName} = define_system gensokyo;
      homeConfigurations.${gensokyo.profiles.nue} = define_hm gensokyo gensokyo.profiles.nue;

      # New research lab
      nixosConfigurations.${grandline.hostName} = define_system grandline;
      homeConfigurations.${grandline.profiles.zoro} = define_hm grandline grandline.profiles.zoro;
    };
}

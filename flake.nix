{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/master";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
        systems.follows = "systems";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };
    RikaOS-private = {
      type = "git";
      url = "git@github.com:o-dasher/RikaOS-private.git";
      ref = "main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-davinci.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        agenix.follows = "agenix";
      };
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
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
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
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://playit-nixos-module.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      stylix,
      nixpkgs-bleeding,
      agenix,
      RikaOS-private,
      mnw,
      nixgl,
      playit-nixos-module,
      flake-parts,
      systems,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      get_pkgs =
        nixpkgs:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      pkgs = get_pkgs nixpkgs;
      pkgs-bleeding = get_pkgs nixpkgs-bleeding;
      pkgs-stable = get_pkgs nixpkgs-stable;

      # Hosts configurations
      systemCfgs = {
        hinamizawa = {
          state = "24.11";
          profiles = {
            rika = "rika";
            satoko = "satoko";
          };
        };
        gensokyo = {
          state = "24.05";
          profiles = {
            nue = "thiago";
          };
        };
      };

      # Home manager only configurations
      homeCfgs = {
        wired = {
          hostName = "gpmecatronica-System-Product-Name";
          state = "24.05";
          profiles = {
            thiagogpm = "thiagogpm";
          };
        };
      };

      commonArgs = {
        inherit RikaOS-private;
        inherit pkgs-stable;
        inherit pkgs-bleeding;
        inherit inputs;
      };

      # Helper to build a NixOS system
      mkSystem =
        targetHostName: cfg:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonArgs // {
            cfg = cfg // {
              inherit targetHostName;
            };
          };
          modules = [
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            playit-nixos-module.nixosModules.default
            ./modules/nixos
            ./hosts/${targetHostName}/configuration.nix
          ];
        };

      # Helper to build a home-manager configuration
      mkHome =
        targetHostName: cfg: username:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            RikaOS-private.homeModules.default
            agenix.homeManagerModules.default
            stylix.homeModules.stylix
            mnw.homeManagerModules.mnw
            ./modules/home
            ./hosts/${targetHostName}/users/${username}
          ];
          extraSpecialArgs = commonArgs // {
            inherit nixgl;
            utils =
              (import ./lib/utils.nix {
                lib = nixpkgs.lib;
                config = self.homeConfigurations.${username}.config;
              })
              // {
                css = import ./modules/home/features/desktop/theme/utils.nix;
              };
            cfg = cfg // {
              inherit username;
              inherit targetHostName;
            };
          };
        };
    in
    (flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = (
              with pkgs;
              [
                nixfmt-rfc-style
                stylua
                prettierd
              ]
            );
          };
        };

      flake = {
        # Generate all nixosConfigurations
        nixosConfigurations = nixpkgs.lib.mapAttrs' (
          targetHostName: cfg:
          nixpkgs.lib.nameValuePair (cfg.hostName or targetHostName) (mkSystem targetHostName cfg)
        ) systemCfgs;

        # Generate all homeConfigurations
        homeConfigurations =
          let
            allCfgs = systemCfgs // homeCfgs;
            users = nixpkgs.lib.flatten (
              nixpkgs.lib.mapAttrsToList (
                targetHostName: cfg:
                nixpkgs.lib.mapAttrsToList (_: username: {
                  name = username;
                  value = mkHome targetHostName cfg username;
                }) cfg.profiles
              ) allCfgs
            );
          in
          nixpkgs.lib.listToAttrs users;
      };
    });
}

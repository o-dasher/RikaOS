{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/master";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.flake-utils.follows = "flake-utils";
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
      inputs.home-manager.follows = "home-manager";
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
    stylix = {
      url = "github:danth/stylix";
      inputs = {
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
      agenix,
      nixpkgs,
      home-manager,
      stylix,
      nixpkgs-bleeding,
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
      pkgs-bleeding = import nixpkgs-bleeding { inherit system; };

      inherit (import ./nixo/systems.nix) systemCfgs homeCfgs;

      # Helper to build a NixOS system
      mkSystem =
        targetHostName: cfg:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit RikaOS-private;
            inherit pkgs-bleeding;
            inherit inputs;
            cfg = cfg // {
              inherit targetHostName;
            };
          };
          modules = [
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            playit-nixos-module.nixosModules.default
            ./nixo/system/modules
            ./nixo/system/${targetHostName}/configuration.nix
          ];
        };

      # Helper to build a home-manager configuration
      mkHome =
        targetHostName: cfg: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          modules = [
            agenix.homeManagerModules.default
            stylix.homeModules.stylix
            mnw.homeManagerModules.mnw
            ./nixo/home/modules
            # The path to user profile
            ./nixo/system/${targetHostName}/profiles/${username}
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit RikaOS-private;
            inherit pkgs-bleeding;
            inherit nixgl;
            utils = import ./nixo/home/utils {
              lib = nixpkgs.lib;
              config = self.homeConfigurations.${username}.config;
            };
            cfg = cfg // {
              inherit username;
              inherit targetHostName;
            };
          };
        };

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
    in
    (
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
      })
      // {
        age = {
          identityPaths = [ "/var/lib/persistent/ssh_host_ed25519_key" ];
          secrets = {
            playit-secret.file = ./nixo/secrets/playit-secret.age;
          };
        };

        inherit nixosConfigurations homeConfigurations;
      }
    );
}

{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs = {
        systems.follows = "systems";
        pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-nixcord.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sidra = {
      url = "github:wimpysworld/sidra";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      agenix,
      flake-parts,
      nixcord,
      hyprland,
      stylix,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      # Single source of truth for the Lix revision package set used across the flake
      lixSet = pkgs: pkgs.lixPackageSets.stable;

      # Helper to import a nixpkgs revision with standard config
      mkPkgs =
        system: p: overlays:
        import p {
          inherit system overlays;
          config.allowUnfree = true;
        };

      systemConfigs = {
        hinamizawa = {
          stateVersion = "26.05";
          system = "x86_64-linux";
          users = [
            "rika"
            "satoko"
          ];
        };
        gensokyo = {
          stateVersion = "24.05";
          system = "x86_64-linux";
          users = [ "thiago" ];
        };
      };

      deploymentTargets = {
        gensokyo = { };
        hinamizawa = { };
      };

      targetSystems = lib.unique (map (c: c.system) (lib.attrValues systemConfigs));

      extraSpecialArgs = {
        inherit inputs;
        nixCaches = {
          extra-substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://hercules-ci.cachix.org"
            "https://cache.numtide.com"
            "https://hyprland.cachix.org"
          ];
          extra-trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          ];
        };
      };

      pkgsFor = lib.genAttrs targetSystems (
        system:
        mkPkgs system nixpkgs [
          (
            _final: prev:
            rec {
              unstable = mkPkgs system nixpkgs-unstable [ ];

              # Packages still not packaged on stable or needing unstable
              inherit (unstable)
                antigravity-cli
                brave-origin
                openrgb
                openrgb-plugin-effects
                wayle
                ;

              # Lix
              inherit (lixSet prev)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
                ;
            }
            // {
              # Hyprland & dependencies
              inherit (hyprland.packages.${system})
                hyprland
                xdg-desktop-portal-hyprland
                ;
            }
          )
        ]
      );

      mkHomeModules =
        hostName:
        {
          username,
          stateVersion,
          ...
        }:
        [
          ./modules/home
          ./hosts/${hostName}/users/${username}
          agenix.homeManagerModules.default
          nixcord.homeModules.nixcord
          {
            home = {
              homeDirectory = "/home/${username}";
              inherit username stateVersion;
            };
          }
        ];

      mkSystemModules =
        hostName:
        {
          system,
          stateVersion,
          users ? [ ],
          ...
        }:
        [
          { nix.package = (lixSet pkgsFor.${system}).lix; }
          ./modules/nixos
          ./hosts/${hostName}/configuration.nix
          stylix.nixosModules.stylix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nixpkgs.pkgs = pkgsFor.${system};
            networking = { inherit hostName; };
            system = { inherit stateVersion; };
            features.core.colmena.enable = deploymentTargets ? ${hostName};
            home-manager = {
              inherit extraSpecialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users = lib.genAttrs users (
                username: { ... }: {
                  imports = mkHomeModules hostName {
                    inherit stateVersion username;
                  };
                }
              );
            };
          }
        ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.git-hooks.flakeModule ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree;

          pre-commit.settings.hooks = {
            # Formatters
            nixfmt.enable = true;
            stylua.enable = true;

            # Linters & Static Analysis
            biome.enable = true;
            deadnix.enable = true;
            statix.enable = true;

            # Hygiene
            trim-trailing-whitespace.enable = true;
            end-of-file-fixer.enable = true;
          };

          devShells.default = pkgs.mkShell {
            inherit (config.pre-commit) shellHook;
            packages =
              with pkgs;
              [
                # lsps
                marksman
                nixd
                lua-language-server
                vscode-json-languageserver
              ]
              ++ config.pre-commit.settings.enabledPackages;
          };
        };

      flake = {
        nixosConfigurations = lib.mapAttrs (
          hostName: cfg:
          lib.nixosSystem {
            specialArgs = extraSpecialArgs;
            inherit (cfg) system;
            modules = mkSystemModules hostName cfg;
          }
        ) systemConfigs;

        homeConfigurations = lib.concatMapAttrs (
          hostName:
          cfg@{ system, users, ... }:
          lib.foldl' lib.mergeAttrs { } (
            map (
              username:
              let
                hmConfig = home-manager.lib.homeManagerConfiguration {
                  inherit extraSpecialArgs;
                  pkgs = pkgsFor.${system};
                  modules = [
                    { nix.package = (lixSet pkgsFor.${system}).lix; }
                    stylix.homeModules.stylix
                  ]
                  ++ mkHomeModules hostName (cfg // { inherit username; });
                };
              in
              {
                "${username}" = hmConfig;
                "${username}@${hostName}" = hmConfig;
              }
            ) users
          )
        ) systemConfigs;

        colmena = {
          meta = {
            nixpkgs = pkgsFor.${lib.head targetSystems};
            nodeNixpkgs = lib.mapAttrs (_: cfg: pkgsFor.${cfg.system}) systemConfigs;
            specialArgs = extraSpecialArgs;
          };
        }
        // lib.mapAttrs (hostName: cfg: {
          imports = mkSystemModules hostName cfg;

          # Workaround: Colmena's eval.nix injects its evaluator package config (meta.nixpkgs.config)
          # into the node. However, NixOS asserts that nixpkgs.config must be empty when
          # nixpkgs.pkgs is explicitly defined by the user.
          nixpkgs.config = lib.mkForce { };
          deployment = {
            targetHost = hostName;
            targetUser = "colmena";
            tags = [ hostName ];
            buildOnTarget = false;
          }
          // (deploymentTargets.${hostName} or { });
        }) systemConfigs;
      };
    };
}

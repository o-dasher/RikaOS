{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
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
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      hyprland,
      home-manager,
      agenix,
      flake-parts,
      playit-nixos-module,
      nix-minecraft,
      nixcord,
      stylix,
      nixpkgs-stable,
      nixpkgs-master,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      # Single source of truth for the Lix revision package set used across the flake
      lixSet = pkgs: pkgs.lixPackageSets.git;

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

      homeConfigs = { };
      deploymentTargets = {
        wired = { };
        gensokyo.targetHost = "fuio.dshs.cc";
        hinamizawa = { };
      };

      targetSystems = lib.unique (
        map (c: c.system) (lib.attrValues systemConfigs ++ lib.attrValues homeConfigs)
      );

      extraSpecialArgs = {
        inherit inputs;
        nixCaches = {
          extra-substituters = [
            "https://cache.nixos.org"
            "https://hyprland.cachix.org"
            "https://playit-nixos-module.cachix.org"
            "https://nix-community.cachix.org"
            "https://hercules-ci.cachix.org"
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
      };

      pkgsFor = lib.genAttrs targetSystems (
        system:
        mkPkgs system nixpkgs [
          nix-minecraft.overlay
          hyprland.overlays.hyprland-packages
          hyprland.overlays.hyprland-extras
          # PR #15580: refactor rendermonitor and early out on no damage frames
          # https://github.com/hyprwm/Hyprland/pull/15580
          # When this PR is merged, the patch will fail to apply and the build
          # will break — remove this overlay at that point.
          (final: prev: {
            hyprland = prev.hyprland.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ [
                (prev.fetchpatch {
                  url = "https://github.com/hyprwm/Hyprland/pull/15580.diff";
                  hash = "sha256-t+r+gplvIoGslj3G662qUW4WAofaDaahvFNXrmWKsII=";
                })
              ];
            });
          })
          (
            final: prev:
            let
              lix = lixSet prev;
            in
            {
              stable = mkPkgs system nixpkgs-stable [ ];
              master = mkPkgs system nixpkgs-master [ ];

              # Lix
              inherit (lix)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
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
          playit-nixos-module.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
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
                    inherit stateVersion username system;
                  };
                }
              );
            };
          }
        ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt
            nixfmt-tree
            stylua
            lua-language-server
            nixd
            nil
            statix
          ];
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
          lib.genAttrs users (
            username:
            home-manager.lib.homeManagerConfiguration {
              inherit extraSpecialArgs;
              pkgs = pkgsFor.${system};
              modules = {
                nix.package = (lixSet pkgsFor.${system}).lix;
              }
              // mkHomeModules hostName (cfg // { inherit username; });
            }
          )
        ) homeConfigs;

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

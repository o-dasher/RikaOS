{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
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
        git-hooks.follows = "git-hooks";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
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
        nur.follows = "nur";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    hyprselect = {
      url = "github:jmanc3/hyprselect";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      agenix,
      flake-parts,
      nixcord,
      nixpkgs-stable,
      nix-minecraft,
      playit-nixos-module,
      nur,
      nixpkgs-master,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      getLixSet = pkgs: pkgs.lixPackageSets.git;
      mkPkgs =
        pkgs: system:
        import pkgs {
          inherit system;
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
            "https://playit-nixos-module.cachix.org"
            "https://nix-community.cachix.org"
            "https://hercules-ci.cachix.org"
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
      };

      pkgsFor = lib.genAttrs targetSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            nix-minecraft.overlay
            nur.overlays.default
            (final: prev: {
              stable = mkPkgs nixpkgs-stable system;
              master = mkPkgs nixpkgs-master system;

              # Lix
              inherit (getLixSet prev)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
                ;

              # Fix gnome-keyring detection in Antigravity IDE
              antigravity-ide = prev.antigravity-ide.override {
                commandLineArgs = "--password-store=gnome-libsecret";
              };

              # Fixes keyboard input when switching workspace.
              foliate = prev.symlinkJoin {
                inherit (prev.foliate) name meta;
                paths = [ prev.foliate ];
                nativeBuildInputs = [ prev.makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/foliate --set GDK_BACKEND x11
                '';
              };

              # Gamescope
              gamescope = prev.gamescope.overrideAttrs (old: {
                # Blur fix: https://github.com/ValveSoftware/gamescope/issues/1622.
                NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [ "-fno-fast-math" ];
                patches = (old.patches or [ ]) ++ [
                  # Fix Gamescope not closing https://github.com/ValveSoftware/gamescope/pull/1908
                  (prev.fetchpatch {
                    url = "https://github.com/ValveSoftware/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.diff";
                    hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
                  })
                ];
              });
            })
          ];
        }
      );

      mkCommonModules = system: [
        { nix.package = (getLixSet pkgsFor.${system}).lix; }
      ];

      mkHomeModules =
        hostName:
        { username, stateVersion, ... }:
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
        mkCommonModules system
        ++ [
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
                username:
                { ... }:
                {
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

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt
              treefmt
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
              modules = mkCommonModules system ++ mkHomeModules hostName (cfg // { inherit username; });
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

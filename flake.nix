{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    ai-nix = {
      url = "github:o-dasher/ai-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        llm-agents.follows = "llm-agents";
      };
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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
        flake-compat.follows = "flake-compat";
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
    walker = {
      url = "github:abenz1267/walker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      agenix,
      flake-parts,
      nixcord,
      spicetify-nix,
      nixpkgs-stable,
      walker,
      nix-minecraft,
      playit-nixos-module,
      llm-agents,
      nur,
      nixpkgs-master,
      zen-browser,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      getLixRevision = pkgs: pkgs.lixPackageSets.git;

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
        wired = {
          stateVersion = "26.05";
          system = "x86_64-linux";
        };
      };

      homeConfigs = { };

      deploymentTargets = {
        wired = { };
        gensokyo = { };
        hinamizawa = { };
      };

      targetSystems = lib.unique (
        (lib.mapAttrsToList (_: { system, ... }: system) systemConfigs)
        ++ (lib.mapAttrsToList (_: { system, ... }: system) homeConfigs)
      );

      extraSpecialArgs = {
        inherit inputs;
        nixCaches = {
          extra-substituters = [
            "https://cache.nixos.org"
            "https://playit-nixos-module.cachix.org"
            "https://nix-community.cachix.org"
            "https://attic.xuyh0120.win/lantian"
            "https://cache.garnix.io"
            "https://hercules-ci.cachix.org"
            "https://walker.cachix.org"
            "https://walker-git.cachix.org"
            "https://ai-nix.cachix.org"
            "https://cache.numtide.com"
          ];
          extra-trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
            "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
            "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
            "ai-nix.cachix.org-1:rUfdPFgb+6TNgKxm7BbanFKIprQed0/SHvQK68DPsCg="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };
      };

      pkgsFor =
        let
          mkPkgs =
            pkgs: system:
            import pkgs {
              inherit system;
              config = {
                permittedInsecurePackages = [ "electron-39.8.10" ];
                allowUnfree = true;
              };
            };
        in
        lib.genAttrs targetSystems (
          system:
          (mkPkgs nixpkgs system).appendOverlays [
            nix-minecraft.overlay
            nur.overlays.default
            (final: prev: {
              stable = mkPkgs nixpkgs-stable system;
              master = mkPkgs nixpkgs-master system;

              # Lix
              inherit (getLixRevision prev)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena
                ;

              # Bleeding edge
              inherit (walker.packages.${system}) walker;
              inherit (llm-agents.packages.${system})
                codex
                copilot-cli
                ;

              # Fix gnome-keyring detection in Antigravity IDE
              antigravity = prev.antigravity.override {
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
              # TODO: wait for https://github.com/nixos/nixpkgs/issues/526914
              bitwarden-desktop = prev.bitwarden-desktop.override { electron_39 = final.electron_39-bin; };

              # Gamescope
              gamescope = (prev.gamescope.override { enableWsi = true; }).overrideAttrs (old: {
                # Blur fix: https://github.com/ValveSoftware/gamescope/issues/1622.
                NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
                patches = old.patches or [ ] ++ [
                  # Fix Gamescope not closing https://github.com/ValveSoftware/gamescope/pull/1908
                  (prev.fetchpatch {
                    url = "https://github.com/ValveSoftware/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.diff";
                    hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
                  })
                ];
              });
            })
          ]
        );

      mkCommonModules = system: [
        { nix.package = (getLixRevision pkgsFor.${system}).lix; }
      ];

      mkHomeModules =
        hostName:
        { username, stateVersion, ... }:
        [
          ./modules/home
          ./hosts/${hostName}/users/${username}
          spicetify-nix.homeManagerModules.spicetify
          agenix.homeManagerModules.default
          nixcord.homeModules.nixcord
          zen-browser.homeModules.twilight
          walker.homeManagerModules.default
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
            features.core.colmena.enable = builtins.hasAttr hostName deploymentTargets;
            home-manager = {
              inherit extraSpecialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users = lib.listToAttrs (
                map (
                  username:
                  lib.nameValuePair username (
                    { ... }:
                    {
                      imports = mkHomeModules hostName {
                        inherit stateVersion username;
                      };
                    }
                  )
                ) users
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
          hostName:
          systemConfig@{ system, ... }:
          lib.nixosSystem {
            inherit system;
            specialArgs = extraSpecialArgs;
            modules = mkSystemModules hostName systemConfig;
          }
        ) systemConfigs;

        homeConfigurations = lib.listToAttrs (
          lib.flatten (
            lib.mapAttrsToList (
              hostName:
              homeConfig@{ system, users, ... }:
              map (username: {
                name = username;
                value = home-manager.lib.homeManagerConfiguration {
                  inherit extraSpecialArgs;
                  pkgs = pkgsFor.${system};
                  modules = mkCommonModules system ++ mkHomeModules hostName (homeConfig // { inherit username; });
                };
              }) users
            ) homeConfigs
          )
        );

        colmena = {
          meta = {
            nixpkgs = pkgsFor.${lib.head targetSystems};
            nodeNixpkgs = lib.mapAttrs (_: systemConfig: pkgsFor.${systemConfig.system}) systemConfigs;
            specialArgs = extraSpecialArgs;
          };
        }
        // lib.mapAttrs (hostName: systemConfig: {
          imports = mkSystemModules hostName systemConfig;

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
          // (lib.attrByPath [ hostName ] { } deploymentTargets);
        }) systemConfigs;
      };
    };
}

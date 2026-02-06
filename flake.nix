{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    pam-shim = {
      url = "github:Cu3PO42/pam_shim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord/02c730b57b8ef16c62624a3410ef724d014c58db";
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
    waybar = {
      url = "github:Alexays/Waybar";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
      zen-browser,
      mnw,
      flake-parts,
      pam-shim,
      systems,
      nixcord,
      spicetify-nix,
      nixpkgs-stable,
      waybar,
      walker,
      nix-flatpak,
      nix-minecraft,
      playit-nixos-module,
      neovim-nightly-overlay,
      ...
    }@inputs:
    let
      getNixImpl = pkgs: pkgs.lixPackageSets.git.lix;
      mkPkgs =
        pkgs: system:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
        };

      overlays = [
        inputs.nix-minecraft.overlay
        waybar.overlays.default
        neovim-nightly-overlay.overlays.default
        (
          final: prev:
          let
            inherit (prev.stdenv.hostPlatform) system;
          in
          {
            stable = mkPkgs nixpkgs-stable system;

            # Lix
            inherit (getNixImpl prev)
              nixpkgs-review
              nix-eval-jobs
              nix-fast-build
              colmena
              ;

            # Bleeding edge
            inherit (walker.packages.${system}) walker;

            # Gamescope
            gamescope = prev.gamescope.overrideAttrs (old: {
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

            # Utilities
            zen-browser = zen-browser.packages.${system}.twilight;
          }
        )
      ];

      systemConfigs = {
        hinamizawa = {
          stateVersion = "24.11";
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

      nixCaches = rec {
        trusted-substituters = substituters;
        substituters = [
          "https://cache.nixos.org"
          "https://playit-nixos-module.cachix.org"
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://cache.garnix.io"
          "https://hercules-ci.cachix.org"
          "https://walker.cachix.org"
          "https://walker-git.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
          "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
        ];
      };

      extraSpecialArgs = {
        inherit
          inputs
          nixCaches
          ;
      };

      mkCommonModules = pkgs: [
        { nix.package = getNixImpl pkgs; }
      ];

      mkHomeModules =
        hostName:
        {
          username,
          ...
        }@homeConfig:
        [
          ./modules/home
          ./hosts/${hostName}/users/${username}
          spicetify-nix.homeManagerModules.spicetify
          agenix.homeManagerModules.default
          pam-shim.homeModules.default
          nixcord.homeModules.nixcord
          mnw.homeManagerModules.mnw
          zen-browser.homeModules.twilight
          walker.homeManagerModules.default
          nix-flatpak.homeManagerModules.nix-flatpak
          { home = ({ homeDirectory = "/home/${username}"; } // homeConfig); }
        ];

      mkSystem =
        hostName:
        {
          system,
          stateVersion,
          users,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = extraSpecialArgs;
          modules = (mkCommonModules (mkPkgs nixpkgs system)) ++ [
            ./modules/nixos
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            playit-nixos-module.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            nix-minecraft.nixosModules.minecraft-servers
            {
              nixpkgs = { inherit overlays; };
              networking = { inherit hostName; };
              system = { inherit stateVersion; };
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users = nixpkgs.lib.listToAttrs (
                  map (
                    username:
                    nixpkgs.lib.nameValuePair username (
                      { ... }:
                      {
                        imports = mkHomeModules hostName {
                          inherit stateVersion;
                          inherit username;
                        };
                      }
                    )
                  ) users
                );
              };
            }
          ];
        };

      mkHome =
        hostName:
        { system, ... }@homeConfig:
        home-manager.lib.homeManagerConfiguration rec {
          inherit extraSpecialArgs;
          pkgs = mkPkgs nixpkgs system;
          modules = (mkCommonModules pkgs) ++ (mkHomeModules hostName homeConfig);
        };
    in
    (flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt
              treefmt
              stylua
            ];
          };
        };

      flake = {
        nixosConfigurations = nixpkgs.lib.mapAttrs' (
          hostName: systemConfig: nixpkgs.lib.nameValuePair hostName (mkSystem hostName systemConfig)
        ) systemConfigs;

        homeConfigurations = nixpkgs.lib.listToAttrs (
          nixpkgs.lib.flatten (
            nixpkgs.lib.mapAttrsToList (
              hostName: homeConfig:
              map (name: {
                inherit name;
                value = mkHome hostName homeConfig;
              }) homeConfig.users
            ) homeConfigs
          )
        );
      };
    });
}

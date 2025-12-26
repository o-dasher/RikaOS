{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/master";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.pre-commit-hooks.follows = "git-hooks";
      inputs.systems.follows = "systems";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
    };
    playit-nixos-module = {
      url = "github:pedorich-n/playit-nixos-module";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "git-hooks";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nix-gaming,
      home-manager,
      stylix,
      nixpkgs-bleeding,
      agenix,
      zen-browser,
      mnw,
      nixgl,
      playit-nixos-module,
      flake-parts,
      systems,
      nixcord,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://hyprland.cachix.org"
        "https://playit-nixos-module.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
        "https://pre-commit-hooks.cachix.org"
        "https://hercules-ci.cachix.org"
      ];

      nixCaches = {
        inherit substituters;
        trusted-substituters = substituters;
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
          "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
        ];
      };

      get_pkgs =
        nixpkgs:
        import nixpkgs {
          inherit system;
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
        inherit pkgs-stable;
        inherit pkgs-bleeding;
        inherit inputs;
        inherit nixCaches;
      };

      commonHomeModules = [
        ./modules/home
        agenix.homeManagerModules.default
        nixcord.homeModules.nixcord
        mnw.homeManagerModules.mnw
        zen-browser.homeModules.twilight
      ];

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
            ./modules/nixos
            ./hosts/${targetHostName}/configuration.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            nix-gaming.nixosModules.pipewireLowLatency
            playit-nixos-module.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = false; # I prefer ~/.nix-profile because of gh auth, etc.
                extraSpecialArgs = commonArgs // {
                  inherit nixgl;
                };
                users = nixpkgs.lib.mapAttrs' (
                  _: username:
                  nixpkgs.lib.nameValuePair username (
                    { config, lib, ... }:
                    {
                      _module.args.utils = (import ./lib/utils.nix { inherit config lib; }) // {
                        css = import ./modules/home/features/desktop/theme/utils.nix;
                      };
                      _module.args.cfg = cfg // {
                        inherit username;
                        inherit targetHostName;
                      };
                      imports = commonHomeModules ++ [
                        ./hosts/${targetHostName}/users/${username}
                      ];
                      home = {
                        inherit username;
                        homeDirectory = "/home/${username}";
                        stateVersion = cfg.state;
                      };
                    }
                  )
                ) cfg.profiles;
              };
            }
          ];
        };

      # Helper to build a home-manager configuration
      mkHome =
        targetHostName: cfg: username:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = commonHomeModules ++ [
            ./hosts/${targetHostName}/users/${username}
            stylix.homeModules.stylix
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
            allCfgs = homeCfgs;
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

{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-gaming,
      home-manager,
      stylix,
      agenix,
      zen-browser,
      mnw,
      playit-nixos-module,
      flake-parts,
      systems,
      nixcord,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };

      substituters = [
        "https://cache.nixos.org"
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
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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

      systemCfgs = {
        hinamizawa = {
          state = "24.11";
          users = [
            "rika"
            "satoko"
          ];
        };
        gensokyo = {
          state = "24.05";
          users = [
            "thiago"
          ];
        };
      };

      homeCfgs = {
        # wired = {
        #   hostName = "gpmecatronica-System-Product-Name";
        #   state = "24.05";
        #   users = {
        #     thiagogpm = "thiagogpm";
        #   };
        # };
      };

      commonArgs = {
        inherit
          inputs
          nixCaches
          ;
      };

      commonHomeModules = [
        ./modules/home
        agenix.homeManagerModules.default
        nixcord.homeModules.nixcord
        mnw.homeManagerModules.mnw
        zen-browser.homeModules.twilight
      ];

      mkSystem =
        hostName: systemCfg:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonArgs;
          modules = [
            ./modules/nixos
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            agenix.nixosModules.default
            nix-gaming.nixosModules.pipewireLowLatency
            playit-nixos-module.nixosModules.default
            {
              networking.hostName = hostName;
              system.stateVersion = systemCfg.state;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = commonArgs;
                users = nixpkgs.lib.listToAttrs (
                  map (
                    username:
                    nixpkgs.lib.nameValuePair username (
                      { ... }:
                      {
                        imports = commonHomeModules ++ [ ./hosts/${hostName}/users/${username} ];
                        home = {
                          inherit username;
                          homeDirectory = "/home/${username}";
                          stateVersion = systemCfg.state;
                        };
                      }
                    )
                  ) systemCfg.users
                );
              };
            }
          ];
        };

      mkHome =
        hostName: homeCfg: username:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = commonHomeModules ++ [
            ./hosts/${hostName}/users/${username}
            stylix.homeModules.stylix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                stateVersion = homeCfg.state;
              };
            }
          ];
          extraSpecialArgs = commonArgs;
        };
    in
    (flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt-rfc-style
              stylua
            ];
          };
        };

      flake = {
        nixosConfigurations = nixpkgs.lib.mapAttrs' (
          hostName: cfg: nixpkgs.lib.nameValuePair (cfg.hostName or hostName) (mkSystem hostName cfg)
        ) systemCfgs;

        homeConfigurations =
          let
            users = nixpkgs.lib.flatten (
              nixpkgs.lib.mapAttrsToList (
                hostName: cfg:
                map (username: {
                  name = username;
                  value = mkHome hostName cfg username;
                }) cfg.users
              ) homeCfgs
            );
          in
          nixpkgs.lib.listToAttrs users;
      };
    });
}

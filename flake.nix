{
  description = "RikaOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";
    mnw.url = "github:Gerg-L/mnw";
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    pam-shim = {
      url = "github:Cu3PO42/pam_shim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
      url = "github:nix-community/stylix";
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
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    hyprnix = {
      url = "path:./lib/inputs/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.git-hooks.follows = "git-hooks";
      inputs.flake-parts.follows = "flake-parts";
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
      flake-parts,
      pam-shim,
      systems,
      nixcord,
      spicetify-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # pkgs_master = import nixpkgs-master {
      #   inherit system;
      #   config.allowunfree = true;
      # };

      overlays = [
        (
          final: prev:
          let
          in
          {
            # Bleeding edge
            # inherit (pkgs_master);
            neovim-nightly = (inputs.neovim-nightly.packages.${prev.stdenv.hostPlatform.system}).neovim;
            inherit (inputs.walker.packages.${prev.stdenv.hostPlatform.system}) walker;

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
            zen-browser = zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
          }
          // (
            if prev.stdenv.hostPlatform.system == "x86_64-linux" then
              # Hyprland packages (from hyprnix nested flake)
              inputs.hyprnix.packages.${prev.stdenv.hostPlatform.system}
            else
              { }
          )
        )
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
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

      homeCfgs = { };

      nixCaches = rec {
        trusted-substituters = substituters;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://cache.garnix.io"
          "https://hercules-ci.cachix.org"
          "https://walker.cachix.org"
          "https://walker-git.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
          "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
        ];
      };

      commonArgs = {
        inherit
          inputs
          nixCaches
          ;
      };

      get_common_home_modules = hostName: username: stateVersion: [
        ./modules/home
        ./hosts/${hostName}/users/${username}
        spicetify-nix.homeManagerModules.spicetify
        agenix.homeManagerModules.default
        pam-shim.homeModules.default
        nixcord.homeModules.nixcord
        mnw.homeManagerModules.mnw
        zen-browser.homeModules.twilight
        inputs.walker.homeManagerModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        {
          home = {
            inherit username;
            inherit stateVersion;
            homeDirectory = "/home/${username}";
          };
        }
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
            inputs.nix-flatpak.nixosModules.nix-flatpak
            {
              nixpkgs.overlays = overlays;
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
                        imports = get_common_home_modules hostName username systemCfg.state;
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
          extraSpecialArgs = commonArgs;
          modules = get_common_home_modules hostName username homeCfg.state;
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

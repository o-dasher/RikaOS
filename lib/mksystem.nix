{ inputs, overlays, nixCaches }:

name:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    inherit overlays;
  };

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-bleeding = import inputs.nixpkgs-bleeding {
    inherit system;
    config.allowUnfree = true;
  };

  commonArgs = {
    inherit inputs nixCaches pkgs-stable pkgs-bleeding;
  };

  hostDir = ../hosts/${name};
  userDir = "${hostDir}/users";

  users =
    if builtins.pathExists userDir
    then builtins.attrNames (builtins.readDir userDir)
    else [];

  commonHomeModules = [
    ../modules/home
    inputs.agenix.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.mnw.homeManagerModules.mnw
    inputs.zen-browser.homeModules.twilight
  ];

in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = commonArgs // {
    # Additional special args can be added here
  };

  modules = [
    ../modules/nixos
    "${hostDir}/configuration.nix"
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.agenix.nixosModules.default
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.playit-nixos-module.nixosModules.default

    {
      networking.hostName = name;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = false;

        extraSpecialArgs = commonArgs // {
          inherit (inputs) nixgl;
        };

        users = inputs.nixpkgs.lib.genAttrs users (username:
          { config, lib, osConfig, ... }: {
            _module.args.utils = (import ./utils.nix { inherit config lib; }) // {
              css = import ../modules/home/features/desktop/theme/utils.nix;
            };

            imports = commonHomeModules ++ [
              "${userDir}/${username}"
            ];

            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = osConfig.system.stateVersion;
            };
          }
        );
      };
    }
  ];
}

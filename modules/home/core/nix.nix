{ lib, config, osConfig ? null, ... }:
{
  options.nixSetup.enable = lib.mkEnableOption "nixSetup" // {
    default = true;
  };

  config = lib.mkMerge [
    (lib.mkIf config.nixSetup.enable {
      nix = {
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 1d";
        };
      };
    })
    (lib.mkIf (osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
      nixpkgs.config.allowUnfree = true;
    })
  ];
}

{ lib, config, ... }:
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
    {
      nixpkgs.config.allowUnfree = true;
    }
  ];
}

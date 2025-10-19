{ lib, config, ... }:
{

  options.nixSetup.enable = lib.mkEnableOption "nixSetup";

  config = lib.mkIf config.nixSetup.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 1d";
      };
    };
  };
}

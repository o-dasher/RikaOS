{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.utilities.enable = lib.mkEnableOption "Utilities profile";

  config = lib.mkIf config.profiles.utilities.enable {
    programs = {
      htop.enable = true;
      yazi.enable = true;
    };

    home.packages = with pkgs; [
      # general
      gdu
      unzip
      # monitor
      mission-center
      lm_sensors
    ];
  };
}

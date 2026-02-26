{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.utilities;
in
with lib;
{
  options.profiles.utilities.enable = mkEnableOption "Utilities profile";

  config = mkIf cfg.enable {
    programs = {
      htop.enable = true;
      yazi = {
        enable = true;
        shellWrapperName = "y";
      };
    };

    home.packages = with pkgs; [
      # webcam
      scrcpy
      # general
      gdu
      unzip
      # monitor
      mission-center
      lm_sensors
      # updates
      nvfetcher
    ];
  };
}

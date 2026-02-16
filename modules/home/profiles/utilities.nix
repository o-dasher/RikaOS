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

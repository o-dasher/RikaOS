{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.profiles.utilities;
in
with lib;
{
  config = mkIf modCfg.enable {
    programs = {
      htop.enable = true;
      yazi.enable = true;
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

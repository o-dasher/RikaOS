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
      yazi.enable = true;
      scrcpy.enable = true;
      gdu.enable = true;
    };

    home.packages = with pkgs; [
      # general
      unzip
      # monitor
      mission-center
      lm_sensors
      # updates
      nvfetcher
    ];
  };
}

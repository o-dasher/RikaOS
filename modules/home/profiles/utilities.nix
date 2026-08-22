{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.utilities;
in
{
  options.profiles.utilities.enable = lib.mkEnableOption "Utilities profile";

  config = lib.mkIf cfg.enable {
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
      czkawka
      unzip
      # monitor
      mission-center
      lm_sensors
      # updates
      nvfetcher
    ];
  };
}

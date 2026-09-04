{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "Desktop host profile.";
    gaming.enable = lib.mkEnableOption "Desktop gaming features.";
    virtualization.enable = lib.mkEnableOption "Desktop virtualization features.";
  };

  config = lib.mkIf cfg.enable {
    profiles.core.enable = true;
    services = {
      gvfs.enable = true;
      printing.enable = true;
    };
    features = {
      audio.enable = true;
      graphics.enable = true;
      gaming.enable = cfg.gaming.enable;
      virtualization.enable = cfg.virtualization.enable;
      hardware.keyboard.enable = true;
    };
  };
}

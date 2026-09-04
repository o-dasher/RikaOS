{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop host profile";
    gaming.enable = lib.mkEnableOption "desktop gaming features";
    virtualization.enable = lib.mkEnableOption "desktop virtualization features";
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
      gaming.enable = lib.mkIf cfg.gaming.enable true;
      virtualization.enable = lib.mkIf cfg.virtualization.enable true;
      hardware.keyboard.enable = true;
    };
  };
}

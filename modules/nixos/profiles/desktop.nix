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
    programs.umbriel.enable = true;
    hardware = {
      keyboard.qmk.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    services = {
      gvfs.enable = true;
      printing.enable = true;
    };
    features = {
      gaming.enable = cfg.gaming.enable;
      virtualization.enable = cfg.virtualization.enable;
    };
  };
}

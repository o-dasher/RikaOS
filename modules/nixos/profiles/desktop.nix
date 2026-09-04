{ lib, config, ... }:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop host profile with audio, graphics, printing, and peripherals";
    gaming.enable = lib.mkEnableOption "desktop gaming stack including Steam and controller support";
    virtualization.enable = lib.mkEnableOption "desktop virtualization features (Podman and libvirtd)";
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

{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;
in
{
  options.features.services.openrgb.enable = lib.mkEnableOption "OpenRGB.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "black.orp";
    };

    systemd = {
      # Wait for sata-based usb rgb devices.
      services.openrgb.serviceConfig.ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 3";
      tmpfiles.rules = [
        "L+ /var/lib/OpenRGB/${config.services.hardware.openrgb.startupProfile} - - - - ${../../../../assets/OpenRGB/black.orp}"
      ];
    };
  };
}

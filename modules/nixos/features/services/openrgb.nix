{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.startupProfile = "black.orp";

    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB 0755 root root -"
      "L+ /var/lib/OpenRGB/black.orp - - - - ${../../../../assets/OpenRGB/black.orp}"
    ];
  };
}

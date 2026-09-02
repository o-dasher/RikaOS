{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;
in
{
  options.features.services.openrgb.enable = lib.mkEnableOption "openrgb";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "/var/lib/OpenRGB/black.orp";
    };

    systemd.tmpfiles.rules = [
      "L+ ${config.services.hardware.openrgb.startupProfile} - - - - ${../../../../assets/OpenRGB/black.orp}"
    ];
  };
}

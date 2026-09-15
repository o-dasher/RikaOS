{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;
  profileName = config.services.hardware.openrgb.startupProfile;
in
{
  options.features.services.openrgb.enable = lib.mkEnableOption "OpenRGB.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "black";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB/profiles 0755 root root -"
      "L+ /var/lib/OpenRGB/Configuration.json - - - - ${../../../../assets/OpenRGB/Configuration.json}"
      "L+ /var/lib/OpenRGB/profiles/${profileName}.json - - - - ${../../../../assets/OpenRGB/black.json}"
      "L+ /var/lib/OpenRGB/black.orp - - - - ${../../../../assets/OpenRGB/black.orp}"
    ];
  };
}

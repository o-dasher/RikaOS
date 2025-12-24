{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.services.openrgb = {
    enable = lib.mkEnableOption "openrgb";
  };

  config = lib.mkIf config.features.services.openrgb.enable {
    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.startupProfile = "black.orp";

    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB 0755 root root -"
      "L+ /var/lib/OpenRGB/black.orp - - - - ${../../../../assets/OpenRGB/black.orp}"
    ];
  };
}

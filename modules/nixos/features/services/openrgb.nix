{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;

  openrgbProfile = "/var/lib/OpenRGB/${config.services.hardware.openrgb.startupProfile}";
  openrgbReloadCmd = "${pkgs.openrgb}/bin/openrgb --profile ${openrgbProfile}";
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "black.orp";
    };

    systemd = {
      tmpfiles.rules = [
        "d /var/lib/OpenRGB 0755 root root -"
        "L+ /var/lib/OpenRGB/black.orp - - - - ${../../../../assets/OpenRGB/black.orp}"
      ];
      services = {
        systemd-suspend.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-hybrid-sleep.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-suspend-then-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
      };
    };
  };
}

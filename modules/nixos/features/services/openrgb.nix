{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;

  openrgbProfile = config.services.hardware.openrgb.startupProfile;
  openrgbReloadCmd = "${pkgs.openrgb}/bin/openrgb --profile ${openrgbProfile}";
in
with lib;
{
  options.features.services.openrgb.enable = mkEnableOption "openrgb";

  config = mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "/var/lib/OpenRGB/black.orp";
    };

    systemd = {
      tmpfiles.rules = [ "L+ ${openrgbProfile} - - - - ${../../../../assets/OpenRGB/black.orp}" ];
      services = {
        openrgb.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-suspend.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-hybrid-sleep.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
        systemd-suspend-then-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [ openrgbReloadCmd ];
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.openrgb;
  profileName = config.services.hardware.openrgb.startupProfile;
  openrgbReloadScript = pkgs.writeShellScript "openrgb-reload" ''
    ${lib.getExe' pkgs.coreutils "sleep"} 3
    ${lib.getExe pkgs.openrgb} --profile ${profileName} || true
  '';
in
{
  options.features.services.openrgb.enable = lib.mkEnableOption "OpenRGB.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "black";
    };

    systemd = {
      # Wait for sata-based usb rgb devices.
      services = {
        openrgb.serviceConfig = {
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 3";
          ExecStartPost = lib.mkAfter [ "${openrgbReloadScript}" ];
        };
        systemd-suspend.serviceConfig.ExecStartPost = lib.mkAfter [ "${openrgbReloadScript}" ];
        systemd-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [ "${openrgbReloadScript}" ];
        systemd-hybrid-sleep.serviceConfig.ExecStartPost = lib.mkAfter [ "${openrgbReloadScript}" ];
        systemd-suspend-then-hibernate.serviceConfig.ExecStartPost = lib.mkAfter [
          "${openrgbReloadScript}"
        ];
      };

      tmpfiles.rules = [
        "d /var/lib/OpenRGB/profiles 0755 root root -"
        "L+ /var/lib/OpenRGB/Configuration.json - - - - ${../../../../assets/OpenRGB/Configuration.json}"
        "L+ /var/lib/OpenRGB/profiles/${profileName}.json - - - - ${../../../../assets/OpenRGB/black.json}"
        "L+ /var/lib/OpenRGB/black.orp - - - - ${../../../../assets/OpenRGB/black.orp}"
      ];
    };
  };
}

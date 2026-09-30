{
  pkgs,
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
      package = pkgs.openrgb.withPlugins [ pkgs.openrgb-plugin-effects ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB/profiles 0755 root root -"
      "L+ /var/lib/OpenRGB/Configuration.json - - - - ${../../../../assets/OpenRGB/Configuration.json}"
      "L+ /var/lib/OpenRGB/profiles/${profileName}.json - - - - ${../../../../assets/OpenRGB/black.json}"
    ];

    systemd.services = {
      openrgb = {
        after = [
          "systemd-modules-load.service"
          "systemd-udevd.service"
        ];
        wants = [
          "systemd-modules-load.service"
          "systemd-udevd.service"
        ];
      };

      openrgb-resume = {
        description = "Restart OpenRGB to restore ${profileName} profile after sleep";
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        unitConfig.StopWhenUnneeded = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "${pkgs.systemd}/bin/systemctl try-restart openrgb.service";
        };
      };
    };
  };
}

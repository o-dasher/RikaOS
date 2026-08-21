{ lib, config, ... }:
let
  cfg = config.features.core.systemCleanup;
in
{
  options.features.core.systemCleanup = {
    enable = lib.mkEnableOption "system cleanup and log retention limits" // {
      default = true;
    };
  };

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    # Limit journald log size to prevent unbounded growth
    services.journald.extraConfig = ''
      SystemMaxUse=512M
      SystemMaxFileSize=128M
      MaxRetentionSec=16day
    '';

    # Clean /tmp directory on boot
    boot.tmp.cleanOnBoot = true;

    # Purge old temporary files and caches via systemd-tmpfiles
    systemd.tmpfiles.rules = [
      "d /tmp 1777 root root 8d"
      "d /var/tmp 1777 root root 16d"
      "e /var/cache - - - 16d -"
    ];
  };
}

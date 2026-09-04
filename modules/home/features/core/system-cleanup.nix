{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.features.core.systemCleanup;
in
{
  options.features.core.systemCleanup = {
    enable = lib.mkEnableOption "Automatic user cache cleanup." // {
      default = true;
    };
    cacheRetentionDays = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Age threshold (in days) to purge stale user cache files.";
    };
    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "Schedule for systemd user cleanup timer.";
    };
  };

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    systemd.user.tmpfiles.rules = [
      # Recursively clean stale files in ~/.cache older than cacheRetentionDays
      "e %h/.cache - - - ${toString cfg.cacheRetentionDays}d -"
    ];

    # Automatically run user tmpfiles cleanup on a schedule in the background
    systemd.user.services.tmpfiles-clean = {
      Unit.Description = "Cleanup stale user cache and temporary files";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemd-tmpfiles --user --clean";
      };
    };

    systemd.user.timers.tmpfiles-clean = {
      Unit.Description = "Scheduled cleanup of user cache and temporary files";
      Timer = {
        OnCalendar = cfg.schedule;
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.features.utilities.trash;
in
{
  options.features.utilities.trash = {
    enable = lib.mkEnableOption "trash alias + cleanup";
    retentionDays = lib.mkOption {
      type = lib.types.int;
      default = 14;
      description = "Delete Trash items older than this many days";
    };
    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "systemd user timer OnCalendar schedule";
    };
    aliasRm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Alias rm to trash-put in fish";
    };
  };

  config = lib.mkIf (config.features.utilities.enable && cfg.enable) {
    home.packages = [ pkgs.trash-cli ];

    home.shellAliases = lib.mkIf cfg.aliasRm {
      rm = "trash-put";
    };

    systemd.user.services.trash-cleanup = {
      Unit.Description = "Cleanup old Trash files";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.trash-cli}/bin/trash-empty ${toString cfg.retentionDays}";
      };
    };

    systemd.user.timers.trash-cleanup = {
      Unit.Description = "Scheduled Trash cleanup";
      Timer = {
        OnCalendar = cfg.schedule;
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

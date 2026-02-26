{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.utilities;
  cfg = modCfg.trash;
in
with lib;
{
  options.features.utilities.trash = {
    enable = mkEnableOption "trash alias + cleanup";
    retentionDays = mkOption {
      type = types.int;
      default = 14;
      description = "Delete Trash items older than this many days";
    };
    schedule = mkOption {
      type = types.str;
      default = "daily";
      description = "systemd user timer OnCalendar schedule";
    };
    aliasRm = mkOption {
      type = types.bool;
      default = true;
      description = "Alias rm to trash-put in fish";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.trash-cli ];

    home.shellAliases = mkIf cfg.aliasRm {
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

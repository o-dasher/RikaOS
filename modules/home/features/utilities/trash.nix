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

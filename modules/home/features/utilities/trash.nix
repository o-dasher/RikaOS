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
  options.features.utilities.trash.enable = lib.mkEnableOption "Trash utilities.";

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ pkgs.trash-cli ];
      shellAliases.rm = "trash-put";
    };

    systemd.user.services.trash-cleanup = {
      Unit.Description = "Cleanup old Trash files";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.trash-cli}/bin/trash-empty 16";
      };
    };

    systemd.user.timers.trash-cleanup = {
      Unit.Description = "Scheduled Trash cleanup";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

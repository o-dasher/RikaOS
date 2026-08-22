{ lib, config, ... }:
let
  cfg = config.features.development.direnv;
in
{
  options.features.development.direnv = {
    enable = lib.mkEnableOption "direnv";
    autoPrune = lib.mkEnableOption "automatic background pruning of stale direnv environments" // {
      default = true;
    };
  };

  config = lib.mkIf (config.features.development.enable && cfg.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    systemd.user.services.direnv-prune = lib.mkIf cfg.autoPrune {
      Unit.Description = "Prune dead direnv environments";
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe config.programs.direnv.package} prune";
      };
    };

    systemd.user.timers.direnv-prune = lib.mkIf cfg.autoPrune {
      Unit.Description = "Scheduled cleanup of dead direnv environments";
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

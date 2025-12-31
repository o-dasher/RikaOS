{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.gaming.steam;
in
{
  options.features.gaming.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkIf (config.features.gaming.enable && cfg.enable) {
    systemd.user.services.steam = {
      Unit = {
        Description = "Steam Client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.steam} -silent";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}

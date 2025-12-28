{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.qbittorrent;
in
{
  options.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent service";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent-nox
      qbittorrent
    ];

    systemd.user.services.qbittorrent-nox = {
      Unit = {
        Description = "qBittorrent-nox headless service";
        After = [ "network.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.qbittorrent-nox}";
        Restart = "on-failure";
      };
    };
  };
}

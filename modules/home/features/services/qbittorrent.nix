{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbittorrent;
in
{
  options.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent user service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "WebUI port";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.qbittorrent-nox ];

    systemd.user.services.qbittorrent = {
      Unit = {
        Description = "qBittorrent-nox User Service";
        After = [ "network.target" ];
        Documentation = [ "man:qbittorrent-nox(1)" ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.qbittorrent-nox} --webui-port=${toString cfg.port}";
        Restart = "on-failure";
        # Security hardening (optional but good practice)
        NoNewPrivileges = true;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

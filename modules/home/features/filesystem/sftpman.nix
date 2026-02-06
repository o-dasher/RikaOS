{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.sftpman;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.mounts != { }) {
    home.packages = [ pkgs.sshfs ];

    programs.sftpman = {
      enable = true;
      inherit (cfg) defaultSshKey mounts;
    };

    systemd.user.services.sftpman-automount = mkIf cfg.automount.enable {
      Unit = {
        Description = "Automount sftpman mounts";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.sftpman}/bin/sftpman mount_all";
        RemainAfterExit = true;
        Environment = [ "SSH_AUTH_SOCK=%t/ssh-agent" ];
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}

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
      defaultSshKey = mkDefault "~/.ssh/id_ed25519";
      mounts = mapAttrs (name: mount: {
        inherit (mount)
          host
          user
          mountPoint
          mountDestPath
          authType
          mountOptions
          ;
        sshKey = if mount.sshKey != null then mount.sshKey else "~/.ssh/id_ed25519";
      }) cfg.mounts;
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
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}

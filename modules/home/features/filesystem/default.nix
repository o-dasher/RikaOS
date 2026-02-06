{ lib, ... }:
with lib;
{
  imports = [
    ./sftpman.nix
  ];

  options.features.filesystem = {
    sftpman = {
      automount.enable = mkEnableOption "sftpman automount via systemd";
      mounts = mkOption {
        default = { };
        description = "sftpman mounts with sensible defaults";
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                host = mkOption { type = types.str; };
                user = mkOption { type = types.str; };
                mountPoint = mkOption { type = types.str; };
                mountDestPath = mkOption {
                  type = types.str;
                  default = "~/mnt/${name}";
                };
              authType = mkOption {
                type = types.str;
                default = "publickey";
              };
              sshKey = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              mountOptions = mkOption {
                type = types.listOf types.str;
                default = [
                  "reconnect"
                  "ServerAliveInterval=15"
                  "ServerAliveCountMax=3"
                  "ConnectTimeout=5"
                  "default_permissions"
                  "nodev"
                  "nosuid"
                  "noexec"
                ];
              };
            };
            }
          )
        );
      };
    };
    enable = mkEnableOption "filesystem features" // {
      default = true;
    };
  };
}

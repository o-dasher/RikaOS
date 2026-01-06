{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.filesystem.bitlocker;

  driveOpts =
    { name, ... }:
    {
      options = {
        device = mkOption {
          type = types.str;
          example = "/dev/disk/by-partlabel/Windows";
        };
        mountPoint = mkOption {
          type = types.str;
          default = "/${name}";
        };
        keyFile = mkOption {
          type = types.path;
          description = "Path to the decrypted secret provided by agenix.";
        };
      };
    };
in
{
  options.features.filesystem.bitlocker = {
    enable = mkEnableOption "BitLocker declarative unlock";

    mountOptions = mkOption {
      type = types.listOf types.str;
      default = [
        "rw"
        "noatime"
        "uid=1000"
        "gid=100"
        "discard"
        "iocharset=utf8"
      ];
    };

    drives = mkOption {
      type = types.attrsOf (types.submodule driveOpts);
      default = { };
    };
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems.ntfs = true;
    systemd.services.bitlocker-unlock = {
      description = "Unlock BitLocker drives via agenix secrets";

      # Crucial: wait for agenix to decrypt secrets into /run/secrets/
      after = [
        "systemd-udev-settle.service"
        "agenix.service"
      ];
      wants = [ "agenix.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        Environment = "PATH=${
          makeBinPath (
            with pkgs;
            [
              coreutils
              cryptsetup
              util-linux
            ]
          )
        }";
      };

      script = concatStringsSep "\n" (
        mapAttrsToList (
          name: drive:
          # bash
          ''
            # Skip if the device is already unlocked
            if [ -e /dev/mapper/${name} ]; then
              echo "Device ${name} is already unlocked, skipping..."
            else
              # 1. Read key, strip newlines/spaces, and pipe it
              # 2. Use --key-file=- to read from the pipe
              cat ${drive.keyFile} | tr -d '[:space:]' | cryptsetup open --type bitlk ${drive.device} ${name} \
                --key-file=- --allow-discards --verbose
            fi

            # Mount if not already mounted
            if ! mountpoint -q ${drive.mountPoint}; then
              mkdir -p ${drive.mountPoint}
              mount /dev/mapper/${name} ${drive.mountPoint} -t ntfs3 \
                  -o ${concatStringsSep "," cfg.mountOptions}
            else
              echo "Mount point ${drive.mountPoint} is already mounted, skipping..."
            fi
          '') cfg.drives
      );

      preStop = concatStringsSep "\n" (
        mapAttrsToList (name: drive: ''
          umount -v ${drive.mountPoint} || true
          cryptsetup close -v ${name} || true
        '') cfg.drives
      );
    };
  };
}

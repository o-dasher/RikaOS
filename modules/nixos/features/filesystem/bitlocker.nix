{
  config,
  pkgs,
  lib,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.bitlocker;
in
{
  options.features.filesystem.bitlocker = {
    enable = lib.mkEnableOption "BitLocker declarative unlock";
    defaultKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Default path to the decrypted secret provided by agenix.";
    };
    mountOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "rw"
        "noatime"
        "uid=1000"
        "gid=100"
        "discard"
        "iocharset=utf8"
      ];
    };
    drives = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              device = lib.mkOption {
                type = lib.types.str;
                example = "/dev/disk/by-partlabel/Windows";
              };
              mountPoint = lib.mkOption {
                type = lib.types.str;
                default = "/${name}";
              };
              keyFile = lib.mkOption {
                type = lib.types.path;
                default = cfg.defaultKeyFile;
                description = "Path to the decrypted secret provided by agenix.";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.udisks2.enable = true;
    boot.supportedFilesystems.ntfs = true;

    systemd.services.bitlocker-unlock = {
      description = "Unlock BitLocker drives via agenix secrets";

      # Crucial: wait for agenix to decrypt secrets into /run/secrets/
      after = [
        "systemd-udev-settle.service"
        "agenix.service"
        "udisks2.service"
      ];

      wants = [
        "agenix.service"
        "udisks2.service"
      ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "root";
        Type = "oneshot";
        RemainAfterExit = "yes";
        Environment = "PATH=${
          lib.makeBinPath (
            with pkgs;
            [
              coreutils
              util-linux
              udisks
              ripgrep
              gawk
            ]
          )
        }";
      };

      script = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          _: drive:
          let
            mountOpts = lib.concatStringsSep "," cfg.mountOptions;
          in
          # bash
          ''
            # Unlock via udisksctl using the key file (skip if already unlocked)
            if ! lsblk ${drive.device} -o TYPE -n | rg -q crypt; then
              echo "Unlocking ${drive.device}..."
              cat ${drive.keyFile} | tr -d '[:space:]' | udisksctl unlock -b ${drive.device} --key-file /dev/stdin || echo "Unlock failed or already unlocked, continuing..."
            else
              echo "Device ${drive.device} is already unlocked, skipping..."
            fi

            # Mount the unlocked device at the configured mount point
            CRYPT_DEV=$(lsblk ${drive.device} -o PATH,TYPE -n | awk '$2 == "crypt" { print $1 }')
            if [ -n "$CRYPT_DEV" ]; then
              if ! mountpoint -q "${drive.mountPoint}"; then
                echo "Mounting $CRYPT_DEV at ${drive.mountPoint}..."
                mkdir -p "${drive.mountPoint}"
                mount -t ntfs3 -o ${mountOpts} "$CRYPT_DEV" "${drive.mountPoint}" || echo "Mount failed, continuing..."
              else
                echo "${drive.mountPoint} is already mounted, skipping..."
              fi
            else
              echo "Could not find unlocked crypt device for ${drive.device}"
            fi
          ''
        ) cfg.drives
      );
    };
  };
}

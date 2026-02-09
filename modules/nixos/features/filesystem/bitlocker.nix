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
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    services.udisks2.enable = true;
    boot.supportedFilesystems.ntfs = true;

    # Allow wheel group and root to use udisksctl without polkit authentication
    security.polkit.extraConfig = # js
      ''
        polkit.addRule(function(action, subject) {
          if (action.id.indexOf("org.freedesktop.udisks2.") == 0 &&
              (subject.user == "root" || subject.isInGroup("wheel"))) {
            return polkit.Result.YES;
          }
        });
      '';

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
          makeBinPath (
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

      script = concatStringsSep "\n" (
        mapAttrsToList (
          name: drive:
          let
            mountOpts = concatStringsSep "," cfg.mountOptions;
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

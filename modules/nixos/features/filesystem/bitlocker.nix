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
    security.polkit.extraConfig = ''
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
              ripgrep
              udisks
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
            # Unlock via udisksctl using the key file (skip if already unlocked)
            if ! lsblk ${drive.device} -o TYPE -n | rg -q crypt; then
              echo "Unlocking ${drive.device}..."
              cat ${drive.keyFile} | tr -d '[:space:]' | udisksctl unlock -b ${drive.device} --key-file /dev/stdin || echo "Unlock failed or already unlocked, continuing..."
            else
              echo "Device ${drive.device} is already unlocked, skipping..."
            fi

            # Find the unlocked dm device
            dm_device=$(lsblk -ln -o PATH ${drive.device} | tail -n1)

            # Mount to the desired location
            if ! mountpoint -q ${drive.mountPoint}; then
              mkdir -p ${drive.mountPoint}
              udisksctl mount -b "$dm_device" --options ${concatStringsSep "," cfg.mountOptions} || true
              # Bind mount to desired location if udisks mounted elsewhere
              udisks_mount=$(lsblk -no MOUNTPOINT "$dm_device" | head -n1)
              if [ -n "$udisks_mount" ] && [ "$udisks_mount" != "${drive.mountPoint}" ]; then
                mount --bind "$udisks_mount" ${drive.mountPoint}
              fi
            else
              echo "Mount point ${drive.mountPoint} is already mounted, skipping..."
            fi
          '') cfg.drives
      );

      preStop = concatStringsSep "\n" (
        mapAttrsToList (name: drive: ''
          umount -v ${drive.mountPoint} || true
          dm_device=$(lsblk -ln -o PATH ${drive.device} | tail -n1)
          udisksctl unmount -b "$dm_device" || true
          udisksctl lock -b ${drive.device} || true
        '') cfg.drives
      );
    };
  };
}

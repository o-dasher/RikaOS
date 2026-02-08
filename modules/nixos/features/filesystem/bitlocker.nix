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
          '') cfg.drives
      );
    };
  };
}

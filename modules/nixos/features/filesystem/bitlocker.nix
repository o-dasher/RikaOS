{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.filesystem.bitlocker;
  mountOptions = [
    "rw"
    "noatime"
    "uid=1000"
    "gid=100"
    "discard"
    "iocharset=utf8"
    "nofail"
    "force"
  ];
in
{
  options.features.filesystem.bitlocker = {
    enable = lib.mkEnableOption "BitLocker declarative unlock.";
    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the decrypted secret key file provided by agenix.";
    };
    drives = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      description = "Mapping of BitLocker drive names to encrypted block device paths.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems.ntfs = true;

    # Declarative per-drive systemd unlock units using cryptsetup
    systemd.services = lib.mapAttrs' (
      name: device:
      lib.nameValuePair "bitlk-${name}" {
        description = "Unlock BitLocker drive ${name}";
        after = [ "agenix.service" ];
        wants = [ "agenix.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/tr -d \"\\r\\n\" < ${cfg.keyFile} | ${pkgs.cryptsetup}/bin/cryptsetup open --type bitlk ${device} bitlk-${name} || true'";
          ExecStop = "${pkgs.cryptsetup}/bin/cryptsetup close bitlk-${name} || true";
        };
      }
    ) cfg.drives;

    # Declarative NixOS fileSystems mount points
    fileSystems = lib.mapAttrs' (
      name: _:
      lib.nameValuePair "/${name}" {
        device = "/dev/mapper/bitlk-${name}";
        fsType = "ntfs3";
        options = mountOptions;
      }
    ) cfg.drives;
  };
}

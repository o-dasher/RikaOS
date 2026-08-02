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
        "nofail"
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
    boot.supportedFilesystems.ntfs = true;

    # Declarative per-drive systemd unlock units using cryptsetup
    systemd.services = lib.mapAttrs' (
      name: drive:
      lib.nameValuePair "bitlk-${name}" {
        description = "Unlock BitLocker drive ${name}";
        after = [ "agenix.service" ];
        wants = [ "agenix.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/tr -d \"\\r\\n\" < ${drive.keyFile} | ${pkgs.cryptsetup}/bin/cryptsetup open --type bitlk ${drive.device} bitlk-${name} || true'";
          ExecStop = "${pkgs.cryptsetup}/bin/cryptsetup close bitlk-${name} || true";
        };
      }
    ) cfg.drives;

    # Declarative NixOS fileSystems mount points
    fileSystems = lib.mapAttrs' (
      name: drive:
      lib.nameValuePair drive.mountPoint {
        device = "/dev/mapper/bitlk-${name}";
        fsType = "ntfs3";
        options = cfg.mountOptions;
      }
    ) cfg.drives;
  };
}

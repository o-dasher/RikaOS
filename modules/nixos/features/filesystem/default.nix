{ lib, config, ... }:
with lib;
let
  cfg = config.features.filesystem.bitlocker;

  # Recursive type for folder trees: nested attrsets where leaves are lists of strings
  # Example: { shared.Media = [ "Music" "Movies" ]; } => /shared/Media/Music, /shared/Media/Movies
  folderTreeType = types.attrsOf (types.either (types.listOf types.str) folderTreeType);
in
{
  imports = [
    ./bitlocker.nix
    ./shared-folders.nix
    ./steam-library.nix
  ];

  options.features.filesystem = {
    enable = mkEnableOption "filesystem features" // {
      default = true;
    };
    sharedFolders = {
      folders = mkOption {
        type = folderTreeType;
        default = { };
        description = ''
          Tree-based folder declaration using nested attrsets.
          Example: { shared.Media = [ "Music" "Movies" ]; }
        '';
      };
      folderNames = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Shared folders with group write access (2770, users group). Computed from `folders`.";
      };
      rootFolders = mkOption {
        type = folderTreeType;
        default = { };
        description = ''
          Tree-based declaration for root-owned folders (755 permissions).
          Example: { shared.Media = [ ]; }
        '';
      };
      rootFolderNames = mkOption {
        type = types.listOf types.str;
        description = "Folders owned by root with 755 permissions, suitable for SSH chroot. Computed from `rootFolders`.";
        default = [ ];
      };
    };
    bitlocker = {
      enable = mkEnableOption "BitLocker declarative unlock";
      defaultKeyFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Default path to the decrypted secret provided by agenix.";
      };
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
        default = { };
        type = types.attrsOf (
          types.submodule (
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
                  default = cfg.defaultKeyFile;
                  description = "Path to the decrypted secret provided by agenix.";
                };
              };
            }
          )
        );
      };
    };
    steamLibrary = {
      enable = mkEnableOption "shared steam library location";
      path = mkOption {
        type = types.str;
        default = "/shared/SteamGames";
        description = "Path to the shared steam library";
      };
      group = mkOption {
        type = types.str;
        default = "steam-gamers";
        description = "Group that owns the shared library";
      };
      users = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Users to add to the shared group";
      };
    };
  };
}

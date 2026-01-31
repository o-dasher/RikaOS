{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.filesystem.sharedFolders;
  # Gather all paths into a single list
  allPaths = [ cfg.configurationRoot ] ++ cfg.folderNames;
in
{
  imports = [
    ../../../home/features/core/shared-folders.nix
  ];

  options.features.filesystem.sharedFolders = with lib; {
    folderNames = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Shared folders with group write access (2770, users group).";
    };
    rootFolderNames = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Folders owned by root with 755 permissions, suitable for SSH chroot.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git.config.safe.directory = [ cfg.configurationRoot ];

    # 1. Create the folders (ensures they exist)
    systemd.tmpfiles.rules =
      map (f: "d ${f} 2770 root users - -") allPaths
      ++ map (f: "d ${f} 0755 root root - -") cfg.rootFolderNames;

    # 2. Enforce the "Shared" state (handles existing files & recursion)
    systemd.services.init-shared-folders = {
      description = "Enforce shared folder permissions and ACLs";
      after = [ "local-fs.target" ]; # Wait for mounts
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";

      path = with pkgs; [
        coreutils
        findutils
        acl
      ];

      script = ''
        ${lib.concatMapStringsSep "\n" (
          path:
          #bash
          ''
            echo "Processing ${path}..."
            # Ensure path exists (redundancy for tmpfiles)
            mkdir -p ${path}

            # Force group ownership to 'users'
            chown -R :users ${path}

            # Folders: 2770 (SetGID so new files belong to 'users')
            find ${path} -type d -exec chmod 2770 {} +

            # Files: 0660 (Owner and Group can read/write)
            find ${path} -type f -exec chmod 0660 {} +

            # Set Default ACLs so permissions are inherited by new files
            setfacl -R -m d:g:users:rwx ${path}
            setfacl -R -m g:users:rwx ${path}
          '') allPaths}

        # Root folders: owned by root with 755
        ${lib.concatMapStringsSep "\n" (path: ''
          if [ -d ${path} ]; then
            chown root:root ${path}
            chmod 755 ${path}
          fi
        '') cfg.rootFolderNames}
      '';
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.filesystem.steamLibrary;
in
{
  options.features.filesystem.steamLibrary = {
    enable = lib.mkEnableOption "shared steam library location";

    path = lib.mkOption {
      type = lib.types.str;
      default = "/shared/SteamGames";
      description = "Path to the shared steam library";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "steam-gamers";
      description = "Group that owns the shared library";
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the shared group";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group}.members = cfg.users;

    systemd.services.init-shared-steam-library = {
      description = "Initialize Shared Steam Library permissions and structure";

      after = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      path = with pkgs; [
        coreutils
        findutils
        bash
      ];

      script = ''
        # 1. Create the base structure
        mkdir -p ${cfg.path}/steamapps/{common,compatdata,downloading,shadercache,temp}

        # 2. Force permissions recursively
        # 2775: '2' is the setgid bit, ensuring new files inherit the group
        chown -R root:${cfg.group} ${cfg.path}
        find ${cfg.path} -type d -exec chmod 2775 {} +
        find ${cfg.path} -type f -exec chmod 0664 {} +

        # 3. Apply ACLs for seamless multi-user writing
        # Directly reference setfacl and getfacl from the acl package
        ${pkgs.acl}/bin/setfacl -R -m d:g:${cfg.group}:rwx ${cfg.path}
        ${pkgs.acl}/bin/setfacl -R -m g:${cfg.group}:rwx ${cfg.path}
      '';
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "setup-shared-steam-library" ''
        set -euo pipefail

        ${lib.concatMapStrings (
          user:
          #bash
          ''
            echo "Setting up shared steam library for user: ${user}"

            USER_HOME="/home/${user}"
            SHARED_ROOT="$USER_HOME/.steam/shared"
            SHARED_STEAMAPPS="$SHARED_ROOT/steamapps"
            SOURCE_PATH="${cfg.path}/steamapps"
            LOCAL_STEAM="$USER_HOME/.local/share/Steam/steamapps"

            # 1. Ensure the directory exists
            if [ ! -d "$SHARED_STEAMAPPS" ]; then
              echo "  Creating directory: $SHARED_STEAMAPPS"
              mkdir -p "$SHARED_STEAMAPPS"
            fi

            # 2. Function to create symlink
            create_link() {
              local target="$1"
              local link_name="$2"
              
              if [ -L "$link_name" ]; then
                echo "  Updating existing symlink: $link_name"
                rm "$link_name"
              elif [ -e "$link_name" ]; then
                echo "  WARNING: $link_name exists and is not a symlink. Skipping."
                return
              fi

              ln -s "$target" "$link_name"
              echo "  Linked $link_name -> $target"
            }

            # 3. Create links to the shared library
            create_link "$SOURCE_PATH/common" "$SHARED_STEAMAPPS/common"
            create_link "$SOURCE_PATH/downloading" "$SHARED_STEAMAPPS/downloading"
            create_link "$SOURCE_PATH/shadercache" "$SHARED_STEAMAPPS/shadercache"
            create_link "$SOURCE_PATH/temp" "$SHARED_STEAMAPPS/temp"

            # 4. Link compatdata to the user's local install (must exist!)
            if [ -d "$LOCAL_STEAM/compatdata" ]; then
              create_link "$LOCAL_STEAM/compatdata" "$SHARED_STEAMAPPS/compatdata"
            else
              echo "  WARNING: Local compatdata not found at $LOCAL_STEAM/compatdata."
              echo "           Please run Steam at least once to generate it."
            fi

            # 5. Fix permissions for the structure
            # We created directories as root, so we must give them back to the user
            echo "  Fixing permissions for $SHARED_ROOT..."
            chown -R ${user}:${cfg.group} "$SHARED_ROOT"
          '') cfg.users}

        echo "Shared Steam Library setup complete."
      '')
    ];
  };
}

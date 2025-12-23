{ lib, config, ... }:
let
  cfg = config.services.shared-steam-library;
in
{
  options.services.shared-steam-library = {
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

    systemd.tmpfiles.rules = [
      # Shared Library Structure
      # Ensure the root and subdirectories exist with correct group permissions and ACLs
      "d ${cfg.path} 2770 root ${cfg.group} - -"
      "a+ ${cfg.path} - - - - default:group:${cfg.group}:rwx"

      "d ${cfg.path}/steamapps 2770 root ${cfg.group} - -"
      "a+ ${cfg.path}/steamapps - - - - default:group:${cfg.group}:rwx"

      "d ${cfg.path}/steamapps/common 2770 root ${cfg.group} - -"
      "a+ ${cfg.path}/steamapps/common - - - - default:group:${cfg.group}:rwx"

      "d ${cfg.path}/steamapps/downloading 2770 root ${cfg.group} - -"
      "a+ ${cfg.path}/steamapps/downloading - - - - default:group:${cfg.group}:rwx"

      "d ${cfg.path}/steamapps/shadercache 2770 root ${cfg.group} - -"
      "a+ ${cfg.path}/steamapps/shadercache - - - - default:group:${cfg.group}:rwx"

      "d ${cfg.path}/steamapps/temp 2770 root ${cfg.group} - -"
      "a+ ${cfg.path}/steamapps/temp - - - - default:group:${cfg.group}:rwx"
    ] ++ (
      lib.concatMap (user: [
        # Create the user's "Shared" library mount point
        "d /home/${user}/.steam/shared/steamapps 0755 ${user} users - -"

        # Link shared content folders to the central shared location
        # This allows deduplication of games, downloads, and shader caches
        "L+ /home/${user}/.steam/shared/steamapps/common - - - - ${cfg.path}/steamapps/common"
        "L+ /home/${user}/.steam/shared/steamapps/downloading - - - - ${cfg.path}/steamapps/downloading"
        "L+ /home/${user}/.steam/shared/steamapps/shadercache - - - - ${cfg.path}/steamapps/shadercache"
        "L+ /home/${user}/.steam/shared/steamapps/temp - - - - ${cfg.path}/steamapps/temp"

        # Link compatdata to the user's personal library (usually ~/.local/share/Steam/steamapps/compatdata)
        # This is CRITICAL: Wine prefixes (compatdata) must be owned by the user running them.
        # Sharing them causes permission errors. We redirect this folder back to the user's home.
        "L+ /home/${user}/.steam/shared/steamapps/compatdata - - - - /home/${user}/.local/share/Steam/steamapps/compatdata"
      ]) cfg.users
    );
  };
}
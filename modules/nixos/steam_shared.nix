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
      "d ${cfg.path} 2770 root ${cfg.group} - -"
      "a+ ${cfg.path} - - - - default:group:${cfg.group}:rwx"
    ] ++ (
      lib.concatMap (user: [
        "d /home/${user}/.steam/shared/steamapps 0755 ${user} users - -"
        "L+ /home/${user}/.steam/shared/steamapps/common - - - - ${cfg.path}"
      ]) cfg.users
    );
  };
}

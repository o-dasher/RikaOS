{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.multiUserFiles.shared-steam-library;
in
{
  options.multiUserFiles.shared-steam-library = {
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

      # Ensure basic utilities are available in the script's environment
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

    systemd.tmpfiles.rules = lib.concatMap (user: [
      "L+ /home/${user}/.steam/shared/steamapps/common - - - - ${cfg.path}/steamapps/common"
      "L+ /home/${user}/.steam/shared/steamapps/downloading - - - - ${cfg.path}/steamapps/downloading"
      "L+ /home/${user}/.steam/shared/steamapps/shadercache - - - - ${cfg.path}/steamapps/shadercache"
      "L+ /home/${user}/.steam/shared/steamapps/temp - - - - ${cfg.path}/steamapps/temp"

      # Link compatdata to local user home
      "L+ /home/${user}/.steam/shared/steamapps/compatdata - - - - /home/${user}/.local/share/Steam/steamapps/compatdata"
    ]) cfg.users;
  };
}

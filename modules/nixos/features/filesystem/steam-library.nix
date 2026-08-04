{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.steamLibrary;
  steamDirs = [
    "common"
    "downloading"
    "shadercache"
    "workshop"
    "temp"
  ];
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

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    users.groups.${cfg.group}.members = cfg.users;

    systemd.tmpfiles.settings.steam-library =
      let
        libraryPaths = [
          cfg.path
          "${cfg.path}/steamapps"
        ]
        ++ map (d: "${cfg.path}/steamapps/${d}") steamDirs;
      in
      builtins.listToAttrs (
        map (
          path:
          lib.nameValuePair path {
            d = {
              mode = "2775";
              user = "root";
              group = cfg.group;
            };
            "a+" = {
              argument = "g:${cfg.group}:rwx,d:g:${cfg.group}:rwx";
            };
          }
        ) libraryPaths
      );

    systemd.user.tmpfiles.rules = [
      "d %h/.steam/shared/steamapps 0755 - - -"
      "d %h/.local/share/Steam/steamapps/compatdata 0755 - - -"
      "L+ %h/.steam/shared/steamapps/compatdata - - - - %h/.local/share/Steam/steamapps/compatdata"
    ]
    ++ map (d: "L+ %h/.steam/shared/steamapps/${d} - - - - ${cfg.path}/steamapps/${d}") steamDirs;
  };
}

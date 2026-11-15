{
  lib,
  config,
  ...
}:
let
  cfg = config.features.filesystem.steamLibrary;
  path = "/shared/SteamGames";
  group = "steam-gamers";
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
    enable = lib.mkEnableOption "Shared Steam library.";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the shared Steam group.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${group}.members = cfg.users;

    systemd.tmpfiles.settings.steam-library =
      let
        libraryPaths = [
          path
          "${path}/steamapps"
        ]
        ++ map (d: "${path}/steamapps/${d}") steamDirs;
      in
      builtins.listToAttrs (
        map (
          dirPath:
          lib.nameValuePair dirPath {
            d = {
              inherit group;
              mode = "2775";
              user = "root";
            };
            "a+" = {
              argument = "g:${group}:rwx,d:g:${group}:rwx";
            };
          }
        ) libraryPaths
      );

    systemd.user.tmpfiles.rules = [
      "d %h/.steam/shared/steamapps 0755 - - -"
      "d %h/.local/share/Steam/steamapps/compatdata 0755 - - -"
      "L+ %h/.steam/shared/steamapps/compatdata - - - - %h/.local/share/Steam/steamapps/compatdata"
    ]
    ++ map (d: "L+ %h/.steam/shared/steamapps/${d} - - - - ${path}/steamapps/${d}") steamDirs;
  };
}

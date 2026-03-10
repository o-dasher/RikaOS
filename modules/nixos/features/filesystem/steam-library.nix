{
  lib,
  config,
  pkgs,
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
with lib;
{
  options.features.filesystem.steamLibrary = {
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

  config = mkIf (modCfg.enable && cfg.enable) {
    users.groups.${cfg.group}.members = cfg.users;

    systemd.tmpfiles.settings.steam-library =
      let
        libraryPaths = [
          cfg.path
          "${cfg.path}/steamapps"
        ] ++ map (d: "${cfg.path}/steamapps/${d}") steamDirs;
      in
      builtins.listToAttrs (
        map (path: nameValuePair path {
          d = {
            mode = "2775";
            user = "root";
            group = cfg.group;
          };
          "a+" = {
            argument = "g:${cfg.group}:rwx,d:g:${cfg.group}:rwx";
          };
        }) libraryPaths
      );

    systemd.user.services.setup-shared-steam-library = {
      description = "Setup shared Steam library symlinks";
      wantedBy = [ "default.target" ];
      after = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [ coreutils ];
      script = ''
        SHARED="$HOME/.steam/shared/steamapps"
        LOCAL_STEAM="$HOME/.local/share/Steam/steamapps"
        SRC="${cfg.path}/steamapps"

        # Link all steam apps to the shared folder
        mkdir -p "$SHARED"
        for dir in ${lib.escapeShellArgs steamDirs}; do
          ln -sfnv "$SRC/$dir" "$SHARED/$dir"
        done

        # Link compatdata from user's local Steam install (not shared)
        if [ -d "$LOCAL_STEAM/compatdata" ]; then
          ln -sfnv "$LOCAL_STEAM/compatdata" "$SHARED/compatdata"
        else
          echo "WARNING: Local compatdata not found at $LOCAL_STEAM/compatdata."
          echo "         Please run Steam at least once to generate it."
        fi
      '';
    };
  };
}

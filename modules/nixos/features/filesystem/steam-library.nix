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
    "temp"
  ];
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    users.groups.${cfg.group}.members = cfg.users;

    systemd = {
      tmpfiles.rules = [
        "d ${cfg.path} 2775 root ${cfg.group} - -"
        "d ${cfg.path}/steamapps 2775 root ${cfg.group} - -"
      ]
      ++ (map (d: "d ${cfg.path}/steamapps/${d} 2775 root ${cfg.group} - -") steamDirs);

      services.init-shared-steam-library = {
        description = "Enforce Steam library permissions and ACLs";
        after = [
          "local-fs.target"
          "systemd-tmpfiles-setup.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        path = with pkgs; [
          coreutils
          findutils
          acl
        ];
        script = ''
          chown -R root:${cfg.group} ${cfg.path}
          find ${cfg.path} -type d -exec chmod 2775 {} +
          find ${cfg.path} -type f -exec chmod 0664 {} +
          setfacl -R -m d:g:${cfg.group}:rwx,g:${cfg.group}:rwx ${cfg.path}
        '';
      };
    };

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

        mkdir -p "$SHARED"
        # Link all steam apps to the shared folder
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

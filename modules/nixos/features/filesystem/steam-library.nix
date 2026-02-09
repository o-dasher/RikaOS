{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.steamLibrary;
  steamUserDirs = [ "compatdata" ];
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
      ++ (map (d: "d ${cfg.path}/steamapps/${d} 2775 root ${cfg.group} - -") (
        steamDirs ++ steamUserDirs
      ));

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
        SRC="${cfg.path}/steamapps"

        mkdir -p "$SHARED"
        for dir in ${lib.escapeShellArgs steamDirs}; do
          ln -sfnv "$SRC/$dir" "$SHARED/$dir"
        done

        for dir in ${lib.escapeShellArgs steamUserDirs}; do
          if [ -d "$SRC/$dir" ]; then
            ln -sfnv "$SRC/$dir" "$SHARED/$dir"
          else
            echo "WARNING: $SRC/$dir does not exist. Run Steam first to create it."
          fi
        done
      '';
    };
  };
}

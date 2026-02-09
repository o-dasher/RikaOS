{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.sharedFolders;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.git.config.safe.directory = cfg.folderNames;

    features.filesystem.sharedFolders.folderNames = [
      "/shared"
      "/shared/.config"
      "/shared/.config/public"
      "/shared/.config/private"
    ];

    systemd = {
      tmpfiles.rules =
        map (f: "d ${f} 2770 root users - -") cfg.folderNames
        ++ map (f: "d ${f} 0755 root root - -") cfg.rootFolderNames;

      services.init-shared-folders = {
        description = "Enforce shared folder permissions and ACLs";
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
          ${lib.concatMapStringsSep "\n" (path: ''
            chown -R :users ${path}
            find ${path} -type d -exec chmod 2770 {} +
            find ${path} -type f -exec chmod 0660 {} +
            setfacl -R -m d:g:users:rwx,g:users:rwx ${path}
          '') cfg.folderNames}

          ${lib.concatMapStringsSep "\n" (path: ''
            [ -d ${path} ] && chown root:root ${path} && chmod 755 ${path}
          '') cfg.rootFolderNames}
        '';
      };
    };
  };
}

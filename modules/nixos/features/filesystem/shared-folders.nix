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

    features.filesystem.sharedFolders =
      let
        # flattenFolderTree { shared.Media = [ "Music" "Movies" ]; }
        # => [ "/shared" "/shared/Media" "/shared/Media/Music" "/shared/Media/Movies" ]
        flattenFolderTree =
          let
            flattenPath =
              prefix: tree:
              builtins.concatMap (
                name:
                let
                  subPath = "${prefix}/${name}";
                  value = tree.${name};
                in
                if builtins.isList value then
                  [ subPath ] ++ map (item: "${subPath}/${item}") value
                else
                  [ subPath ] ++ flattenPath subPath value
              ) (builtins.attrNames tree);
          in
          flattenPath "";
      in
      {
        rootFolderNames = flattenFolderTree cfg.rootFolders;
        folderNames = flattenFolderTree (
          recursiveUpdate cfg.folders {
            shared.".config" = [
              "public"
              "private"
            ];
          }
        );
      };

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

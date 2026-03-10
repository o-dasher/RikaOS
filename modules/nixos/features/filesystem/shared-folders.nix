{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.filesystem;
  cfg = modCfg.sharedFolders;

  # Recursive type for folder trees: nested attrsets where leaves are lists of strings
  # Example: { shared.Media = [ "Music" "Movies" ]; } => /shared/Media/Music, /shared/Media/Movies
  folderTreeType = lib.types.attrsOf (
    lib.types.either (lib.types.listOf lib.types.str) folderTreeType
  );
in
with lib;
{
  options.features.filesystem.sharedFolders = {
    folders = mkOption {
      type = folderTreeType;
      default = { };
      description = ''
        Tree-based folder declaration using nested attrsets.
        Example: { shared.Media = [ "Music" "Movies" ]; }
      '';
    };
    folderNames = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Shared folders with group write access (2770, users group). Computed from `folders`.";
    };
    rootFolders = mkOption {
      type = folderTreeType;
      default = { };
      description = ''
        Tree-based declaration for root-owned folders (755 permissions).
        Example: { shared.Media = [ ]; }
      '';
    };
    rootFolderNames = mkOption {
      type = types.listOf types.str;
      description = "Folders owned by root with 755 permissions, suitable for SSH chroot. Computed from `rootFolders`.";
      default = [ ];
    };
  };

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
                [ subPath ]
                ++ (
                  if builtins.isList value then map (item: "${subPath}/${item}") value else flattenPath subPath value
                )
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

    systemd.tmpfiles.settings.shared-folders =
      let
        mkSharedFolderEntry =
          path:
          nameValuePair path {
            d = {
              mode = "2770";
              user = "root";
              group = "users";
            };
            "a+" = {
              argument = "g:users:rwx,d:g:users:rwx";
            };
          };

        mkRootFolderEntry =
          path:
          nameValuePair path {
            d = {
              mode = "0755";
              user = "root";
              group = "root";
            };
          };
      in
      builtins.listToAttrs (map mkSharedFolderEntry cfg.folderNames)
      // builtins.listToAttrs (map mkRootFolderEntry cfg.rootFolderNames);
  };
}

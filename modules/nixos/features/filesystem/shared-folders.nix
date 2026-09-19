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
{
  options.features.filesystem.sharedFolders = {
    folders = lib.mkOption {
      type = folderTreeType;
      default = { };
      description = "Tree-based folder declaration using nested attrsets.";
    };
    folderNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Shared folders with group write access (2770, users group). Computed from `folders`.";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.git.config.safe.directory = cfg.folderNames;

    features.filesystem.sharedFolders = {
      folderNames =
        let
          # flattenFolderTree { shared.Media = [ "Music" "Movies" ]; }
          # => [ "/shared" "/shared/Media" "/shared/Media/Music" "/shared/Media/Movies" ]
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
        flattenPath "" (
          lib.recursiveUpdate cfg.folders {
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
          lib.nameValuePair path {
            d = {
              mode = "2770";
              user = "root";
              group = "users";
            };
            "a+" = {
              argument = "g:users:rwx,d:g:users:rwx";
            };
          };
      in
      builtins.listToAttrs (map mkSharedFolderEntry cfg.folderNames);
  };
}

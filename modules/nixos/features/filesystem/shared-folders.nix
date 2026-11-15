{
  lib,
  config,
  ...
}:
let
  cfg = config.features.filesystem.sharedFolders;
in
{
  options.features.filesystem.sharedFolders = {
    enable = lib.mkEnableOption "Shared folders.";
    folderNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Shared folders with group write access (2770, users group).";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git.config.safe.directory = cfg.folderNames;

    features.filesystem.sharedFolders.folderNames = [
      "/shared"
      "/shared/.config"
      "/shared/.config/public"
      "/shared/.config/private"
    ];

    systemd.tmpfiles.settings.shared-folders = builtins.listToAttrs (
      map (
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
        }
      ) cfg.folderNames
    );
  };
}

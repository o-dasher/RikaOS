{ lib, config, ... }:
{
  imports = [
    ../home/core/shared_folders.nix
  ];

  options.sharedFolders = with lib; {
    folderNames = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
  };

  config = lib.mkIf config.sharedFolders.enable {
    programs.git = {
      enable = true;
      config.safe.directory = [ config.sharedFolders.configurationRoot ];
    };

    systemd.tmpfiles.rules = lib.concatMap (f: [
      "d ${f} 2770 - users - -"
      "a+ ${f} - - - - default:group:users:rwx"
    ]) (
      [
        config.sharedFolders.configurationRoot
      ]
      ++ config.sharedFolders.folderNames
    );
  };
}

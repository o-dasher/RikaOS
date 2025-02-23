{ lib, config, ... }:
{
  imports = [
    ../../home/modules/system/shared_folders.nix
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
      config.safe.directory = config.sharedFolders.configurationRoot;
    };

    systemd.tmpfiles.rules = map (f: "d ${f} 0777 - wheel - -") (
      [
        config.sharedFolders.configurationRoot
      ]
      ++ config.sharedFolders.folderNames
    );
  };
}

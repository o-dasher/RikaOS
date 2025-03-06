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

    systemd.tmpfiles.rules = map (f: "z ${f} 2770 - users - -") (
      [
        config.sharedFolders.configurationRoot
      ]
      ++ config.sharedFolders.folderNames
    );
  };
}

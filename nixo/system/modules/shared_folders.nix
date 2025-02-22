{ lib, config, ... }:
{
  options.sharedFolders = with lib; {
    enable = (mkEnableOption "sharedFolders") // {
      default = true;
    };
    folderNames = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
  };

  config = lib.mkIf (config.sharedFolders.enable) {
    systemd.tmpfiles.rules = map (f: "d ${f} 0777 - wheel - -") (
      [
        "/shared/.config"
      ]
      ++ config.sharedFolders.folderNames
    );
  };
}

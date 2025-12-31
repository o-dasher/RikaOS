{ lib, ... }:
{
  options.features.filesystem.sharedFolders = with lib; {
    enable = (mkEnableOption "sharedFolders") // {
      default = true;
    };
    configurationRoot = mkOption {
      default = "/shared/.config";
      type = types.str;
    };
  };
}

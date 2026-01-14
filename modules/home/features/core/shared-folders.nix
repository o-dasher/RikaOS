{ lib, ... }:
{
  options.features.filesystem.sharedFolders = with lib; {
    enable = mkEnableOption "sharedFolders";
    configurationRoot = mkOption {
      default = "/shared/.config";
      type = types.str;
    };
  };
}

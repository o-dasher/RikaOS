{ lib, ... }:
with lib;
{
  options.features.filesystem = {
    sharedFolders = {
      enable = mkEnableOption "sharedFolders";
      configurationRoot = mkOption {
        default = "/shared/.config";
        type = types.str;
      };
    };
    enable = mkEnableOption "filesystem features" // {
      default = true;
    };
  };
}

{ lib, config, ... }:
{
  options.sharedFolders = with lib; {
    enable = (mkEnableOption "sharedFolders") // {
      default = true;
    };
    configurationRoot = mkOption {
      default = "/shared/.config";
      type = types.str;
    };
  };

  config = lib.mkIf (config.sharedFolders.enable) {
    programs.git = {
      enable = true;
      extraConfig.safe.directory = "/shared/.config";
    };
  };
}

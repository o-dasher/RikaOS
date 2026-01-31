{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.desktop.dolphin = {
    enable = lib.mkEnableOption "dolphin";
  };

  config = lib.mkIf config.features.desktop.dolphin.enable {
    home.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.kio-extras # SFTP, SMB, and other network protocols
      kdePackages.ark # Archive manager
      kdePackages.ffmpegthumbs # Video thumbnails
      kdePackages.kdegraphics-thumbnailers # PDF, PS, RAW, etc thumbnails
      kdePackages.baloo # File indexer for search
      p7zip
    ];
  };
}

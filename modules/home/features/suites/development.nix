{ pkgs, lib, config, ... }:
{
  options.suites.development = {
    enable = lib.mkEnableOption "development suite";
  };

  config = lib.mkIf config.suites.development.enable {
    home.packages = with pkgs; [
      wget
      heroku
      # general
      htop
      gdu
      unzip
      # android
      universal-android-debloater
      # tools
      qbittorrent
      # monitor
      mission-center
      # files
      yazi
      # Disk partitioning
      gparted
    ];
  };
}

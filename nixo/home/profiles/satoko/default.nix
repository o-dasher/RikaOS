{ pkgs, ... }:
{
  imports = [
    ../rika
    ./theme
  ];

  config = {
    hyprland.enable = true;
    spotify.enable = true;

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];

    home.packages = with pkgs; [
      # cli
      # general
      htop
      gdu
      unzip

      # programming
      cargo # Used to start new projects although I mainly use dev shells!
      jetbrains.rider

      # android
      universal-android-debloater

      # gui
      # entertainment
      stremio
      # tools
      gimp
      nomacs
      qbittorrent
      pavucontrol
      obs-studio
      mpv
      # monitor
      mission-center
      # browser 
      brave
      # social media 
      legcord
      # files 
      yazi

      # Disk partitioning
      gparted
    ];

    programs = {
      hyfetch = {
        enable = true;
        settings = {
          preset = "bisexual";
          mode = "rgb";
          color_align.mode = "horizontal";
        };
      };
    };
  };
}

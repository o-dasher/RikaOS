{ pkgs, ... }:
{
  imports = [
    ../rika
    ./sway
    ./mako
    ./waybar
    ./wofi
    ./spotify
    ./theme
  ];

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

    # gui
    # entertainment
    stremio
    # tools
    qbittorrent
    pavucontrol
    obs-studio
    mpv
    # monitor
    mission-center
    # social media
    brave
    # browser
    armcord
    # files 
    yazi
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
}

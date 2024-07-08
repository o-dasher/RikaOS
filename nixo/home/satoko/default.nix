{ pkgs, ... }:
{
  imports = [
    ../rika
    ./sway
    ./swaync
    ./waybar
    ./wofi
    ./spotify
    ./theme
  ];

  home.packages = with pkgs; [
    # cli
    # general
    htop
    gdu
    unzip
    # programming
    cargo # Used to start new projects although I mainly use dev shells!

    # gaming
    lutris
    gamemode

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
    xfce.thunar

    # gaming
    osu-lazer-bin
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

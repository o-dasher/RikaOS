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
    # programming
    cargo # mainly used to start new projects although I mainly use dev shells!

    # clipboard
    wl-clipboard

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

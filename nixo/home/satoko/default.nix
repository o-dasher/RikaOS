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
      };
    };
  };
}

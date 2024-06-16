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

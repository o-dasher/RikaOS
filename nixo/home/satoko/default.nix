{ pkgs, ... }:
{
  imports = [
    ./sway
    ./swaync
    ./waybar
    ./wofi
    ../rika
  ];

  stylix.image = ../../../assets/Wallpapers/rikamoon.jpg;
  home.packages = with pkgs; [
    # Sys utils
    xdg-terminal-exec
    pamixer

    # Desktop
    wofi
    jq
    grimblast
    wl-clipboard

    # General
    brave
    armcord
    qbittorrent
    obs-studio
    stremio
    htop
    xfce.thunar
    gdu
    pavucontrol
    hyfetch
  ];

  programs = {
    mpv = {
      enable = true;
    };
  };
}

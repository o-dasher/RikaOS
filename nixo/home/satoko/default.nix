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

    # Games
    osu-lazer-bin
  ];

  stylix.targets.gtk.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };

  programs = {
    mpv = {
      enable = true;
    };
  };
}

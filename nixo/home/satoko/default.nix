{ pkgs, inputs, ... }:
{
  imports = [
    ./sway
    ./swaync
    ./waybar
    ./wofi
    ../rika
    inputs.spicetify-nix.homeManagerModules.default
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
    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        theme = spicePkgs.themes.text;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
        ];
      };
  };
}

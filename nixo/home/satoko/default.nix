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
    # cli
    # general
    xdg-terminal-exec
    pamixer
    # screenshot
    grimblast
    wl-clipboard
    # monitoring
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };

  programs = {
    hyfetch = {
      enable = true;
      settings = {
        preset = "bisexual";
      };
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

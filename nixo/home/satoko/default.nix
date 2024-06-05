{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.satoko.enable = lib.mkEnableOption "Enable Satoko";

  imports = [
    ./sway
    ./swaync
    ./waybar
    ./wofi
  ];

  config = lib.mkIf config.satoko.enable {
    home.packages = with pkgs; [
      # Sys utils
      xdg-terminal-exec
      pamixer

      # Desktop
      wofi
      swww
      jq
      grimblast
      wl-clipboard
      whitesur-icon-theme

      # General
      brave
      armcord
      qbittorrent
      obs-studio
      stremio
      vial
      htop
      xfce.thunar
      gdu
      pavucontrol
      hyfetch

      # fonts
      jetbrains-mono
      # Disk space is not cheap okay?
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "CascadiaCode"
        ];
      })
    ];

    programs = {
      home-manager.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      mpv = {
        enable = true;
        catppuccin.enable = true;
      };
    };

    gtk = {
      enable = true;
      catppuccin.enable = true;
      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };
    };
  };
}

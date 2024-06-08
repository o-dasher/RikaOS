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
  };
}

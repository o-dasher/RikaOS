{ pkgs, ... }:
{
  terminal.enable = true;
  spotify.enable = true;
  nixSetup.enable = true;

  xdgSetup.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  home.packages = with pkgs; [
    easyeffects
    pavucontrol
    mpv
    mission-center
    brave
  ];

  programs = {
    bash.enable = true;
    home-manager.enable = true;
  };
}

{ pkgs, ... }:
{
  gnome.enable = true;
  fish.enable = true;
  spotify.enable = true;
  nixSetup.enable = true;

  xdgSetup.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  home.packages = with pkgs; [
    mpv
    mission-center
    brave
  ];

  programs = {
    easyeffects.enable = true;
    home-manager.enable = true;
  };
}

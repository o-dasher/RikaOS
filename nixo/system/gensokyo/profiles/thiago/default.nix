{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  xdgSetup.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  home.packages = with pkgs; [
    openjdk
    tmux
  ];

  programs = {
    home-manager.enable = true;
  };
}

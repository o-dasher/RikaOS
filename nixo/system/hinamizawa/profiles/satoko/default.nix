{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  gnome.enable = true;
  terminal.enable = true;
  spotify.enable = true;
  nixSetup.enable = true;

  xdgSetup.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    easyeffects
    mpv
    mission-center
    brave
  ];

  programs = {
    home-manager.enable = true;
  };
}

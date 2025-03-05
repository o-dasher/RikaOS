{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  games.enable = true;
  gnome.enable = true;
  terminal.enable = true;
  spotify.enable = true;

  nixSetup.enable = true;
  xdgSetup.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    easyeffects
    mpv
    mission-center
  ];

  programs = {
    home-manager.enable = true;
    librewolf.enable = true;
  };
}

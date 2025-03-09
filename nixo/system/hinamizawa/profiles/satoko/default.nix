{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  games.enable = true;
  terminal.enable = true;
  spotify.enable = true;
  desktop.gnome.enable = true;

  nixSetup.enable = true;
  xdgSetup.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    mpv
    mission-center
  ];

  services.easyeffects.enable = true;
  programs = {
    home-manager.enable = true;
    librewolf.enable = true;
  };
}

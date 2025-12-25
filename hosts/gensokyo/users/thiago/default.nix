{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openjdk
    tmux
  ];

  xdgSetup.portal.enable = false;
  programs = {
    home-manager.enable = true;
  };
}

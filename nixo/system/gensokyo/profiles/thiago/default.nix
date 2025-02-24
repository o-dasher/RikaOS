{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  xdgSetup.enable = true;
  home.packages = with pkgs; [
    openjdk
    tmux
  ];

  programs = {
    home-manager.enable = true;
  };
}

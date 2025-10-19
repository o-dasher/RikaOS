{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openjdk
    tmux
  ];

  programs = {
    home-manager.enable = true;
  };
}

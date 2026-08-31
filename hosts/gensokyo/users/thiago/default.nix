{ pkgs, ... }:
{
  features = {
    utilities.trash.enable = true;
    development.git.enable = true;
    cli = {
      hyfetch.enable = true;
      fish.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };
  };

  home.packages = with pkgs; [ wol ];
  programs.home-manager.enable = true;
}

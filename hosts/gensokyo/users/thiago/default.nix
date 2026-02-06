{ ... }:
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

  programs.home-manager.enable = true;
}

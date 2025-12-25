{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.development.enable = lib.mkEnableOption "Development profile";

  config = lib.mkIf config.profiles.development.enable {
    editors = {
      neovim.enable = true;
      neovide.enable = true;
      jetbrains = {
        enable = true;
        datagrip.enable = true;
      };
    };

    dev = {
      direnv.enable = true;
      secrets.enable = true;
      git.enable = true;
    };

    cli = {
      hyfetch.enable = true;
      gemini.enable = true;
      fish.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };

    terminal.ghostty.enable = true;

    home.packages = with pkgs; [
      wget
      heroku
    ];
  };
}

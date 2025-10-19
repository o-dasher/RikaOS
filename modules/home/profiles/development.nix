{ lib, config, ... }:
{
  options.profiles.development.enable = lib.mkEnableOption "Development profile";

  config = lib.mkIf config.profiles.development.enable {
    editors = {
      neovim.enable = true;
      neovide.enable = true;
      jetbrains.enable = true;
    };

    dev = {
      direnv.enable = true;
      secrets.enable = true;
      git.enable = true;
    };

    cli = {
      gemini.enable = true;
      fish.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };

    terminal.ghostty.enable = true;
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.development.enable = lib.mkEnableOption "Development profile";

  config = lib.mkIf config.profiles.development.enable {
    features.editors = {
      neovim.enable = true;
      neovim.neovide.enable = true;
      jetbrains = {
        enable = true;
        datagrip.enable = true;
      };
    };

    features.dev = {
      direnv.enable = true;
      secrets.enable = true;
      git.enable = true;
    };

    features.cli = {
      hyfetch.enable = true;
      gemini.enable = true;
      fish.enable = true;
      starship.enable = true;
      tmux.enable = true;
    };

    features.terminal.ghostty.enable = true;

    home.packages = with pkgs; [
      antigravity-fhs
      wget
      heroku
    ];
  };
}

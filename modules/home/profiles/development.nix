{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.development;
in
with lib;
{
  config = mkIf cfg.enable {
    features = {
      terminal.ghostty.enable = true;

      editors = {
        neovim = {
          enable = true;
          neovide.enable = true;
        };
        jetbrains = {
          enable = true;
          datagrip.enable = true;
        };
      };

      development = {
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
    };

    programs.jq.enable = true;
    home.packages = with pkgs; [
      bashInteractive
      ripgrep
      github-copilot-cli
      antigravity-fhs
      google-chrome
      codex
      wget
      heroku
    ];
  };
}

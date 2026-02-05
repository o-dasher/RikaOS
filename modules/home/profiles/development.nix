{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.profiles.development;
in
with lib;
{
  config = mkIf modCfg.enable {
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
    };

    programs.jq.enable = true;
    home.packages = with pkgs; [
      antigravity-fhs
      codex
      wget
      heroku
    ];
  };
}

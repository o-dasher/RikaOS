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
  options.profiles.development.enable = mkEnableOption "Development profile";

  config = mkIf cfg.enable {
    services.gnome-keyring.enable = true;
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

    programs = {

      jq.enable = true;
      ripgrep.enable = true;
    };
    home.packages = with pkgs; [
      bashInteractive
      github-copilot-cli
      antigravity-fhs
      codex
      codex-desktop
      wget
      heroku
    ];
  };
}

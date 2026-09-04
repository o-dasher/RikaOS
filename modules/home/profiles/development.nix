{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development = {
    enable = lib.mkEnableOption "Development profile";
    jetbrains.enable = lib.mkEnableOption "JetBrains IDEs (DataGrip)";
    zed.enable = lib.mkEnableOption "Zed editor";
  };

  config = lib.mkIf cfg.enable {
    services.gnome-keyring.enable = true;
    features = {
      terminal.ghostty.enable = true;

      editors = {
        neovim = {
          enable = true;
          neovide.enable = true;
        };
        jetbrains = lib.mkIf cfg.jetbrains.enable {
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
        fish.enable = true;
        starship.enable = true;
        tmux.enable = true;
      };
    };

    programs = {
      jq.enable = true;
      grep.enable = true;
      ripgrep.enable = true;
      zed-editor.enable = cfg.zed.enable;
      antigravity-cli.enable = true;
      github-copilot-cli.enable = true;
      codex.enable = true;
    };

    home.packages = with pkgs; [
      wget
    ];
  };
}

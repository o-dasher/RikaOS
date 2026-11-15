{ lib, config, ... }:
let
  cfg = config.features.terminal.ghostty;
in
{
  options.features.terminal.ghostty.enable = lib.mkEnableOption "Ghostty.";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = lib.mkAfter {
        scrollback-limit = 10000;
        clipboard-read = "allow";
        gtk-titlebar = false;
        clipboard-paste-protection = false;
      };
    };
  };
}

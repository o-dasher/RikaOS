{ lib, config, ... }:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.ghostty.enable) {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        scrollback-limit = 10000;
        clipboard-read = "allow";
        clipboard-paste-protection = false;
        window-decoration = false;
        gtk-titlebar = false;
      };
    };
  };
}

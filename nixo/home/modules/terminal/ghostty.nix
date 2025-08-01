{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.ghostty.enable) {
    programs.ghostty = {
      enable = true;
      settings = lib.mkAfter {
        font-size = 12;
        scrollback-limit = 10000;
        clipboard-read = "allow";
        gtk-titlebar = false;
        clipboard-paste-protection = false;
      };
    };
  };
}

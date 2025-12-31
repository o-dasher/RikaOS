{ lib, config, ... }:
{
  options.features.terminal.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf config.features.terminal.ghostty.enable {
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

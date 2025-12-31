{ lib, config, ... }:
{
  options.features.terminal.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf config.features.terminal.ghostty.enable {
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

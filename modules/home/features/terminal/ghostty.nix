{ lib, config, ... }:
let
  modCfg = config.features.terminal;
  cfg = modCfg.ghostty;
in
{
  options.features.terminal.ghostty.enable =
    lib.mkEnableOption "Ghostty hardware-accelerated terminal emulator with custom window settings";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
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

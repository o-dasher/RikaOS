{ lib, config, ... }:
let
  modCfg = config.features.terminal;
  cfg = modCfg.ghostty;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.ghostty = {
      enable = true;
      settings = mkAfter {
        scrollback-limit = 10000;
        clipboard-read = "allow";
        gtk-titlebar = false;
        clipboard-paste-protection = false;
      };
    };
  };
}

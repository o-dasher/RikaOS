{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.tmux;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.tmux = {
      enable = true;
      mouse = true;
      extraConfig = # tmux
        ''
          bind-key v split-window -h
        '';
    };
  };
}

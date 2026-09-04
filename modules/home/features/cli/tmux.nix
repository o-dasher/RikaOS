{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.tmux;
in
{
  options.features.cli.tmux.enable = lib.mkEnableOption "Tmux.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.tmux = {
      enable = true;
      mouse = true;
      extraConfig = ''
        bind-key v split-window -h
      '';
    };
  };
}

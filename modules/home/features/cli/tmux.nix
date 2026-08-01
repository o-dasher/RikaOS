{ lib, config, ... }:
let
  cfg = config.features.cli.tmux;
in
{
  options.features.cli.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf (config.features.cli.enable && cfg.enable) {
    programs.tmux = {
      enable = true;
      mouse = true;
      extraConfig = ''
        bind-key v split-window -h
      '';
    };
  };
}

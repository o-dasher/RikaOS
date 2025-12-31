{ lib, config, ... }:
{
  options.features.cli.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.features.cli.tmux.enable {
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

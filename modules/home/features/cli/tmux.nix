{ lib, config, ... }:
{
  options.cli.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.cli.tmux.enable {
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

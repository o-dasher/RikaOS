{ lib, config, ... }:
{
  options.cli.lazygit.enable = lib.mkEnableOption "lazygit";

  config = lib.mkIf config.cli.lazygit.enable {
    programs.lazygit.enable = true;
  };
}

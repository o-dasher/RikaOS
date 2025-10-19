{ lib, config, ... }:
{
  options.dev.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.dev.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

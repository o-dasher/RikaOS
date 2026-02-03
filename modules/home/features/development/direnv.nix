{ lib, config, ... }:
{
  options.features.dev.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.features.dev.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

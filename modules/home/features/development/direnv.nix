{ lib, config, ... }:
let
  cfg = config.features.development.direnv;
in
{
  options.features.development.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf (config.features.development.enable && cfg.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

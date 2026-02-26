{ lib, config, ... }:
let
  modCfg = config.features.development;
  cfg = modCfg.direnv;
in
with lib;
{
  options.features.development.direnv.enable = mkEnableOption "direnv";

  config = mkIf (modCfg.enable && cfg.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

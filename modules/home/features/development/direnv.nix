{ lib, config, ... }:
let
  modCfg = config.features.dev;
  cfg = modCfg.direnv;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

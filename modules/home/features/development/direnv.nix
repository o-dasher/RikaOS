{ lib, config, ... }:
let
  modCfg = config.features.development;
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

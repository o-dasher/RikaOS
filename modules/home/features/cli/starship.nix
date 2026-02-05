{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.starship;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
  };
}

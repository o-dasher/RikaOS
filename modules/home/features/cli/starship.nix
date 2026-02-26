{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.starship;
in
with lib;
{
  options.features.cli.starship.enable = mkEnableOption "starship";

  config = mkIf (modCfg.enable && cfg.enable) {
    programs.starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
  };
}

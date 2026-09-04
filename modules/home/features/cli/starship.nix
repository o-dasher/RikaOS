{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.starship;
in
{
  options.features.cli.starship.enable = lib.mkEnableOption "Starship prompt.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.starship = {
      enable = true;
      settings.gcloud.disabled = true;
    };
  };
}

{ lib, config, ... }:
let
  cfg = config.features.cli.starship;
in
{
  options.features.cli.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf (config.features.cli.enable && cfg.enable) {
    programs.starship = {
      enable = true;
      settings.gcloud.disabled = true;
    };
  };
}

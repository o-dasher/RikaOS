{ lib, config, ... }:
{
  options.features.cli.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.features.cli.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
  };
}

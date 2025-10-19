{ lib, config, ... }:
{
  options.cli.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.cli.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
  };
}

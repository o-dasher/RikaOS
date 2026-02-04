{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    programs.mangohud.enable = true;

    home.packages = with pkgs; [
      goverlay
      parsec-bin
    ];

    features.gaming = {
      enable = true;
      steam.enable = true;
      heroic.enable = true;
    };
  };
}

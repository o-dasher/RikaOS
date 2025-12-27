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

    games = {
      goverlay.enable = true;
      heroic.enable = true;
      lutris.enable = true;
    };
  };
}

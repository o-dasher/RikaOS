{
  lib,
  config,
  ...
}:
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    programs.mangohud.enable = true;

    games = {
      enable = true;
      steam.enable = true;
      heroic.enable = true;
      goverlay.enable = true;
    };
  };
}

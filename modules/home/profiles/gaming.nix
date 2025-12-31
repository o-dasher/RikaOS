{
  lib,
  config,
  ...
}:
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    programs.mangohud.enable = true;

    features.gaming = {
      enable = true;
      steam.enable = true;
      heroic.enable = true;
      goverlay.enable = true;
    };
  };
}

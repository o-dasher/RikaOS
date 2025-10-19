{ lib, config, ... }:
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    games = {
      steam.enable = true;
      mangohud.enable = true;
      goverlay.enable = true;
      heroic.enable = true;
      hydralauncher.enable = true;
    };
  };
}

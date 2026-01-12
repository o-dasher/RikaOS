{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    home.packages = with pkgs; [
      mangohud
      goverlay
    ];

    features.gaming = {
      enable = true;
      steam.enable = true;
      heroic.enable = true;
    };
  };
}

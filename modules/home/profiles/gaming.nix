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
      shadps4
    ];

    games = {
      goverlay.enable = true;
      heroic.enable = true;
      lutris.enable = true;
    };
  };
}

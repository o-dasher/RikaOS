{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.multimedia = {
    enable = lib.mkEnableOption "multimedia profile";
  };

  config = lib.mkIf config.profiles.multimedia.enable {
    home.packages = with pkgs; [
      ardour
      audacity
      aseprite
      krita
      imagemagick
      gimp
      davinci-resolve-studio
      obs-studio
      mpv
      spotify
      # documents / study
      zathura
    ];

    services.easyeffects.enable = true;
  };
}

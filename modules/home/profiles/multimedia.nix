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
    services.easyeffects.enable = true;

    home.packages = with pkgs; [
      # video
      kdePackages.kdenlive
      obs-studio
      mpv

      # drawing
      aseprite
      krita

      # images
      imagemagick
      gimp

      # music
      spotify

      # documents / study
      zathura
    ];
  };
}

{ pkgs, lib, config, ... }:
{
  options.suites.multimedia = {
    enable = lib.mkEnableOption "multimedia suite";
  };

  config = lib.mkIf config.suites.multimedia.enable {
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

    # Enable easyeffects if audio is relevant
    services.easyeffects.enable = true;
  };
}

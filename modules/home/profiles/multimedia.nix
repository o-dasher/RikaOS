{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.multimedia;
in
with lib;
{
  options.profiles.multimedia.enable = mkEnableOption "multimedia profile";

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
    programs = {
      # Video
      mpv.enable = true;
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [ obs-vaapi ];
      };

      # documents / study
      zathura.enable = true;

      # Music
      spicetify.enable = true;
    };

    home.packages = with pkgs; [
      # Downloading
      transmission-remote-gtk

      # Video
      kdePackages.kdenlive
      jellyfin-desktop
      feishin

      # Drawing
      krita

      # Music
      nicotine-plus
    ];

    xdg.configFile = config.rika.utils.mkAutostartApp pkgs.nicotine-plus "${pkgs.nicotine-plus}/bin/nicotine";
  };
}

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

    systemd.user.services.nicotine-plus = config.rika.utils.mkAutostartService "${pkgs.nicotine-plus}/bin/nicotine";
  };
}

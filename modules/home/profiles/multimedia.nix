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
    programs = {
      # Video
      obs-studio.enable = true;
      mpv.enable = true;

      # documents / study
      zathura.enable = true;

      # Music
      spicetify.enable = true;
    };

    home.packages = with pkgs; [
      # Downloading
      transmission-remote-gtk

      # Video
      stable.kdePackages.kdenlive
      jellyfin-desktop

      # Drawing
      krita

      # Music
      nicotine-plus
    ];

    systemd.user.services.nicotine-plus = config.rika.utils.mkAutostartService (
      "${pkgs.nicotine-plus}/bin/nicotine"
    );
  };
}

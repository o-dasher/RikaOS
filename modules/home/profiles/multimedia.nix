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
    };

    home.packages = with pkgs; [
      (pkgs.makeDesktopItem {
        name = "qBittorrent-PWA";
        desktopName = "qBittorrent";
        genericName = "Torrent Client";
        exec = "${lib.getExe pkgs.ungoogled-chromium} --app=http://localhost:8080";
        icon = "qbittorrent";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "P2P"
        ];
      })

      # video
      kdePackages.kdenlive

      # drawing
      aseprite
      krita

      # images
      imagemagick
      gimp

      # music
      spotify
    ];
  };
}

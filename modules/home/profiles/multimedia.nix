{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.multimedia;
in
{
  options.profiles.multimedia.enable = lib.mkEnableOption "Multimedia profile.";

  config = lib.mkIf cfg.enable {
    services.easyeffects.enable = true;
    systemd.user.services.easyeffects = {
      Service.Environment = [ "QT_QPA_PLATFORM=wayland;xcb;offscreen" ];
      Unit = {
        After = [ "pipewire.service" ];
        Wants = [ "pipewire.service" ];
        PartOf = [ "pipewire.service" ];
      };
    };
    profiles.study.enable = lib.mkDefault true;
    programs = {
      # Video
      mpv.enable = true;
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [ obs-vaapi ];
      };
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
      spotify
    ];

    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = pkgs.spotify; }) ];
  };
}

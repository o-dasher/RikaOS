{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.multimedia;
  sidra-pkg = inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.profiles.multimedia.enable = lib.mkEnableOption "Multimedia profile.";

  config = lib.mkIf cfg.enable {
    services.easyeffects.enable = true;
    systemd.user.services.easyeffects = {
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

      # Drawing
      krita

      # Music
      sidra-pkg
    ];

    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = sidra-pkg; }) ];
  };
}

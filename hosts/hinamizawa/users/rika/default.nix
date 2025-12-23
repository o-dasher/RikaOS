{
  inputs,
  pkgs,
  ...
}:
{
  theme.cirnold.enable = true;

  profiles.development.enable = true;
  editors.jetbrains.android-studio.enable = true;
  profiles.gaming.enable = true;

  desktop = {
    hyprland.enable = true;
  };

  games = {
    minecraft.enable = true;
    osu.enable = true;
  };

  home.packages = with pkgs; [
    # cli
    wget
    heroku

    # Security and mailing
    bitwarden-desktop

    # Video
    ardour
    audacity

    # I love my keyboard.
    via
    vial

    # Drawing
    aseprite
    krita

    # documents / study
    imagemagick
    zathura

    # cli
    # general
    htop
    gdu
    unzip

    # android
    universal-android-debloater

    # Browser
    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.twilight

    # tools
    qbittorrent
    pavucontrol

    # images
    gimp
    nomacs

    # videos
    davinci-resolve-studio
    obs-studio
    mpv
    # monitor
    mission-center
    # files
    yazi
    nautilus
    spotify

    # Disk partitioning
    gparted
  ];

  services.easyeffects.enable = true;
  programs = {
    home-manager.enable = true;
    nixcord = {
      enable = true;
      discord.enable = true;
      vesktop.enable = true;
    };
  };

}

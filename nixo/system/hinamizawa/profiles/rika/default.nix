{
  inputs,
  pkgs,
  lib,
  RikaOS-private,
  ...
}:
{
  imports = [
    ../../../../home/modules/theme/graduation.nix
  ];

  development.enable = true;
  development.android.enable = true;

  nixSetup.enable = true;
  xdgSetup.enable = true;

  desktop = {
    gnome.enable = true;
    hyprland.enable = true;
  };

  games = {
    enable = true;
    minecraft.enable = true;
    osu.enable = true;
    steam.enable = true;
  };

  home.packages = with pkgs; [
    # cli
    wget
    heroku
    wl-clipboard # global because I main wayland

    # Security and mailing
    bitwarden-desktop

    # Video
    ardour
    audacity

    # I love my keyboard.
    via
    vial

    # documents / study
    imagemagick
    anki-bin
    zathura

    # cli
    # general
    htop
    gdu
    unzip

    # android
    universal-android-debloater

    # Browser
    inputs.zen-browser.packages.${system}.twilight

    # tools
    gimp
    nomacs
    qbittorrent
    pavucontrol
    obs-studio
    mpv
    # monitor
    mission-center
    # social media
    discord
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
  };
}

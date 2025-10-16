{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../../home/modules/theme/cirnold.nix
  ];

  development.enable = true;
  development.android.enable = true;
  development.games.enable = true;

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
    inputs.zen-browser.packages.${system}.twilight

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

{
  inputs,
  pkgs,
  lib,
  config,
  RikaOS-private,
  ...
}:
{
  imports = [
    ./stylix.nix
  ];

  neovim.enable = true;
  nixSetup.enable = true;
  xdgSetup.enable = true;

  terminal = {
    enable = true;
    ghostty.enable = true;
  };

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

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  xdg.configFile."ideavim" = {
    source = config.lib.file.mkOutOfStoreSymlink ../../../../../ideavim;
    recursive = true;
  };

  home.packages = with pkgs; [
    # cli
    wget
    heroku
    wl-clipboard # global because I main wayland

    # Security and mailing
    bitwarden-desktop

    # editor
    neovide

    # Video
    ardour
    audacity
    (import RikaOS-private.davinci-resolve {
      inherit lib;
      inherit pkgs;
    })

    # I love my keyboard.
    via
    vial

    # documents / study
    imagemagick
    anki-bin
    zathura

    # Fonts
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.jetbrains-mono

    # cli
    # general
    htop
    gdu
    unzip

    # programming
    android-studio

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
    gh.enable = true;
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    hyfetch = {
      enable = true;
      settings = {
        preset = "bisexual";
        mode = "rgb";
        color_align.mode = "horizontal";
      };
    };
  };
}

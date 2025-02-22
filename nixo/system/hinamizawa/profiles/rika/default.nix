{ pkgs, ... }:
{
  imports = [
    ./theme
  ];

  neovim.enable = true;
  terminal.enable = true;
  hyprland.enable = true;
  spotify.enable = true;
  nixSetup.enable = true;

  xdgSetup.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  home.packages = with pkgs; [
    # audio
    easyeffects

    # cli
    wget
    github-cli
    git
    heroku
    wl-clipboard # global because I main wayland

    # Security and mailing
    bitwarden-desktop

    # editor
    neovide

    # database
    beekeeper-studio

    # I love my keyboard.
    via
    vial

    # documents
    zathura

    # fonts
    jetbrains-mono
    cascadia-code

    # cli
    # general
    htop
    gdu
    unzip

    # programming
    jetbrains.rider
    android-studio
    # Used to start new projects although I mainly use dev shells!
    openjdk17
    cargo
    nodejs
    bun
    pnpm

    # android
    universal-android-debloater

    # gui
    # entertainment
    stremio
    # tools
    gimp
    nomacs
    qbittorrent
    pavucontrol
    obs-studio
    mpv
    # monitor
    mission-center
    # browser
    brave
    # social media
    legcord
    # files
    yazi

    # Disk partitioning
    gparted
  ];

  programs = {
    bash.enable = true;
    home-manager.enable = true;
    lazygit.enable = true;
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

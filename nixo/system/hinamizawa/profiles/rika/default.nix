{ pkgs, config, ... }:
{
  imports = [
    ./theme
  ];

  neovim.enable = true;
  terminal.enable = true;
  hyprland.enable = true;
  gnome.enable = true;
  spotify.enable = true;
  nixSetup.enable = true;
  xdgSetup.enable = true;

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

    # database
    beekeeper-studio

    # I love my keyboard.
    via
    vial

    # documents
    zathura

    # Fonts
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono

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
    discord
    # files
    yazi

    # Disk partitioning
    gparted
  ];

  services.easyeffects.enable = true;
  programs = {
    gh.enable = true;
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

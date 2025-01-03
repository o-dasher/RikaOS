{ pkgs, config, ... }:
let
  cfg = config.rika;
in
{
  imports = [
    ./wezterm
    ./fish
    ./theme
    ./neovim
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  xdg.portal = with pkgs; {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
    extraPortals = [ xdg-desktop-portal-gtk ];
  };

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    stateVersion = cfg.state;
    packages = with pkgs; [
      # cli
      wget
      github-cli
      git
      heroku
      wl-clipboard # global because I main wayland

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
      # Disk space is not cheap okay?
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "CascadiaCode"
        ];
      })
    ];
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
    lazygit.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

{ pkgs, cfg, ... }:
{
  imports = [
    ./theme
    ../../modules
  ];

  config = {
    neovim.enable = true;
    terminal.enable = true;

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
  };

}

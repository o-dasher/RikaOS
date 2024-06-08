{ pkgs, config, ... }:
let
  cfg = config.rika;
in
{
  imports = [
    ./wezterm
    ./fish
    ./theme
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    stateVersion = cfg.state;
    packages = with pkgs; [
      # Programming
      devenv
      github-cli
      wget
      git

      # I love my keyboard.
      via
      vial

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
    tmux = {
      enable = true;
      mouse = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        tree-sitter
        ripgrep
        stylua
        gcc
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

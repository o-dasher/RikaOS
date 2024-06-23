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

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    stateVersion = cfg.state;
    packages = with pkgs; [
      # cli
      wget
      devenv
      github-cli
      git

      # database
      beekeeper-studio

      # I love my keyboard.
      via
      vial

      # documents
      zathura
      foliate

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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

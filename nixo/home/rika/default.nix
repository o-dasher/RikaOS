{ pkgs, config, ... }:
let
  cfg = config.rika;
in
{
  imports = [
    ./alacritty
    ./fish
    ./theme
  ];

  home.packages = with pkgs; [
    # Programming
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

  xdg = {
    enable = true;
    mime.enable = true;
  };

  targets.genericLinux.enable = (cfg.hostname != "nixo");
  programs = {
    bash.enable = true;
    home-manager.enable = true;
    lazygit = {
      enable = true;
      catppuccin.enable = true;
    };
    tmux = {
      enable = true;
      mouse = true;
      catppuccin.enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        prettierd
        nixfmt-rfc-style
        stylua
        tree-sitter
        ripgrep
        gcc
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

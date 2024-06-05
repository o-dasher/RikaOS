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
    gcc # Some programs such as neovim require the cpp compiler.
    github-cli
    ripgrep
    wget
    git
    tree-sitter

    # I love my keyboard.
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
    tmux = {
      enable = true;
      catppuccin.enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

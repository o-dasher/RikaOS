{ pkgs, ... }:
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
  ];

  xdg = {
    enable = true;
    mime.enable = true;
  };

  targets.genericLinux.enable = false;
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

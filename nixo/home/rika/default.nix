{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./fish
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

  programs.tmux = {
    enable = true;
    catppuccin.enable = true;
  };
}

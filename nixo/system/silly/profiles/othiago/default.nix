{
  config,
  pkgs,
  inputs,
  nixgl,
  ...
}:
{
  nixGL.packages = nixgl.packages;

  sharedFolders.configurationRoot = "~/RikaOS";

  desktop.gnome.enable = true;

  nixpkgs.config.allowUnfree = true;
  neovim.enable = true;
  terminal.enable = true;
  terminal.ghostty.enable = true;

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;

  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    inputs.zen-browser.packages.${system}.twilight
  ];

  programs = {
    gh.enable = true;
    home-manager.enable = true;
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

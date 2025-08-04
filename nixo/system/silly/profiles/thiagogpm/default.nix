{
  config,
  lib,
  pkgs,
  inputs,
  nixgl,
  ...
}:
{
  imports = [
    ../../../../home/modules/theme/graduation.nix
  ];

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";

  sharedFolders.configurationRoot = "~/Programming/RikaOS";

  desktop.hyprland.enable = true;

  nixpkgs.config.allowUnfree = true;
  neovim.enable = true;
  terminal.enable = true;
  terminal.ghostty.enable = true;

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;

  wayland.windowManager.hyprland.package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);

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

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

  development.enable = true;
  desktop.hyprland.enable = true;

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
  wayland.windowManager.hyprland.package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.twilight
  ];

  programs = {
    home-manager.enable = true;
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

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
    ../../../../../home/modules/theme/cirnold.nix
  ];

  targets.genericLinux.enable = true;

  xdgSetup.enable = true;
  nixSetup.enable = true;

  nixGL.packages = nixgl.packages;
  sharedFolders.configurationRoot = "~/Programming/RikaOS";

  development.enable = true;
  desktop.hyprland.enable = true;

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
  wayland.windowManager.hyprland.package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.twilight
    inputs.agenix.packages.${system}.default
    spotify
  ];

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };
}

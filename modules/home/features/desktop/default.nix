{ lib, ... }:
with lib;
{
  imports = [
    ./fonts.nix
    ./hyprland
    ./theme
    ./wayland
  ];

  options.features.desktop = {
    fonts.enable = mkEnableOption "common fonts" // {
      default = true;
    };
    hyprland.enable = mkEnableOption "hyprland";
    wayland = {
      enable = mkEnableOption "Wayland base integration";
      mako.enable = (mkEnableOption "mako") // {
        default = true;
      };
      waybar.enable = (mkEnableOption "waybar") // {
        default = true;
      };
      walker.enable = (mkEnableOption "walker") // {
        default = true;
      };
    };
    enable = mkEnableOption "desktop features" // {
      default = true;
    };
  };
}

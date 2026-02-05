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
    enable = mkEnableOption "desktop features";
    fonts.enable = mkEnableOption "common fonts" // {
      default = true;
    };
    hyprland.enable = mkEnableOption "hyprland";
    theme.enable = mkEnableOption "desktop theme";
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
  };
}

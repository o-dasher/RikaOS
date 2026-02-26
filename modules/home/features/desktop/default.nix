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
    enable = mkEnableOption "desktop features" // {
      default = true;
    };
  };
}

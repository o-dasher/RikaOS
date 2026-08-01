{ lib, ... }:
{
  imports = [
    ./hyprland
    ./theme
    ./wayland
    ./fonts.nix
  ];

  options.features.desktop = {
    enable = lib.mkEnableOption "desktop features" // {
      default = true;
    };
  };
}

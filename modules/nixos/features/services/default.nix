{ lib, ... }:
with lib;
{
  imports = [
    ./bluetooth.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./openrgb.nix
    ./sddm.nix
  ];

  options.features.services = {
    bluetooth.enable = mkEnableOption "bluetooth";
    flatpak.enable = mkEnableOption "Flatpak support";
    gnome-keyring.enable = mkEnableOption "gnome keyring";
    openrgb.enable = mkEnableOption "openrgb";
    sddm = {
      enable = mkEnableOption "SDDM Display Manager";
      background = mkOption {
        type = types.path;
        description = "Background image for SDDM";
      };
      flavor = mkOption {
        type = types.str;
        description = "Catppuccin flavor for SDDM (e.g., mocha, latte)";
      };
      accent = mkOption {
        type = types.str;
        description = "Catppuccin accent color for SDDM (e.g., mauve, pink)";
      };
    };
    enable = mkEnableOption "service features" // {
      default = true;
    };
  };
}

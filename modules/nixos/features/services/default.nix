{ lib, ... }:
with lib;
{
  imports = [
    ./bluetooth.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./openssh.nix
    ./openrgb.nix
    ./dbus.nix
    ./tailscale.nix
    ./transmission.nix
    ./sddm.nix
  ];

  options.features.services = {
    enable = mkEnableOption "service features" // {
      default = true;
    };
  };
}

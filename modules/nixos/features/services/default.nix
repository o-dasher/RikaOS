{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./gnome-keyring.nix
    ./openrgb.nix
    ./openssh.nix
    ./sddm.nix
    ./sunshine.nix
    ./transmission.nix
  ];

  options.features.services.enable =
    lib.mkEnableOption "system background services (SSH, SDDM, Bluetooth, etc.)"
    // {
      default = true;
    };
}

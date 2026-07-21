{ lib, ... }:
with lib;
{
  imports = [
    ./bluetooth.nix
    ./gnome-keyring.nix
    ./openssh.nix
    ./openrgb.nix
    ./sunshine.nix
    ./transmission.nix
    ./sddm.nix
  ];

  options.features.services = {
    enable = mkEnableOption "service features" // {
      default = true;
    };
  };
}

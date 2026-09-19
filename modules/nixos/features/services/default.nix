{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./gnome-keyring.nix
    ./openrgb.nix
    ./openssh.nix
    ./sddm.nix
    ./transmission.nix
  ];

  options.features.services.enable = lib.mkEnableOption "Background services." // {
    default = true;
  };
}

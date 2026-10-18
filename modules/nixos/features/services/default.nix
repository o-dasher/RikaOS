{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./gnome-keyring.nix
    ./noctalia-greeter.nix
    ./openrgb.nix
    ./openssh.nix
    ./transmission.nix
  ];

  options.features.services.enable = lib.mkEnableOption "Background services." // {
    default = true;
  };
}

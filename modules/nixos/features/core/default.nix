{ lib, ... }:
{
  imports = [
    ./colmena.nix
    ./system-cleanup.nix
    ./user-preferences.nix
  ];

  options.features.core.enable = lib.mkEnableOption "Core system features." // {
    default = true;
  };
}

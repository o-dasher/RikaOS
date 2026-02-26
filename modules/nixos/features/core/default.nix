{ lib, ... }:
with lib;
{
  imports = [
    ./colmena.nix
    ./user-preferences.nix
  ];

  options.features.core = {
    enable = mkEnableOption "core features" // {
      default = true;
    };
  };
}

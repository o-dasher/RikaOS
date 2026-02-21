{ lib, ... }:
with lib;
{
  imports = [
    ./colmena.nix
    ./user-preferences.nix
  ];

  options.features.core = {
    colmena.enable = mkEnableOption "colmena deployment user";
    userPreferences.enable = mkEnableOption "userPreferences";
    enable = mkEnableOption "core features" // {
      default = true;
    };
  };
}

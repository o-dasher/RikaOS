{ lib, ... }:
with lib;
{
  imports = [
    ./user-preferences.nix
  ];

  options.features.core = {
    userPreferences.enable = mkEnableOption "userPreferences";
    enable = mkEnableOption "core features" // {
      default = true;
    };
  };
}

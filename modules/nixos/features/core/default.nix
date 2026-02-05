{ lib, ... }:
with lib;
{
  imports = [
    ./user-preferences.nix
  ];

  options.features.core = {
    enable = mkEnableOption "core features";
    userPreferences.enable = mkEnableOption "userPreferences";
  };
}

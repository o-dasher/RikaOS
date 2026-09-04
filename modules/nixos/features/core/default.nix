{ lib, ... }:
{
  imports = [
    ./colmena.nix
    ./system-cleanup.nix
    ./user-preferences.nix
  ];

  options.features.core.enable =
    lib.mkEnableOption "core system features (deployment user, cleanup, and user preferences)"
    // {
      default = true;
    };
}

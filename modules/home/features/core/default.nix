{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./system-cleanup.nix
    ./xdg.nix
  ];

  options.features.core = {
    enable = lib.mkEnableOption "core features" // {
      default = true;
    };
  };
}

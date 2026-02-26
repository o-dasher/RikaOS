{ lib, ... }:
with lib;
{
  imports = [
    ./xdg.nix
    ./nix.nix
  ];

  options.features.core = {
    enable = mkEnableOption "core features" // {
      default = true;
    };
  };
}

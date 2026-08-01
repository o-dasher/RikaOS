{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./xdg.nix
  ];

  options.features.core = {
    enable = lib.mkEnableOption "core features" // {
      default = true;
    };
  };
}

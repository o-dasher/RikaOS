{ lib, ... }:
{
  imports = [
    ./setup.nix
  ];

  options.features.nix = {
    enable = lib.mkEnableOption "nix" // {
      default = true;
    };
  };
}

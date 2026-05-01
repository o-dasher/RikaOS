{ lib, ... }:
with lib;
{
  imports = [
    ./setup.nix
  ];

  options.features.nix = {
    enable = mkEnableOption "nix" // {
      default = true;
    };
  };
}

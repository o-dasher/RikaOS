{ lib, ... }:
with lib;
{
  imports = [
    ./setup.nix
    ./builders.nix
  ];

  options.features.nix = {
    enable = mkEnableOption "nix" // {
      default = true;
    };
  };
}

{ lib, ... }:
with lib;
{
  imports = [
    ./nemo.nix
    ./trash.nix
  ];

  options.features.utilities = {
    enable = mkEnableOption "utilities" // {
      default = true;
    };
  };
}

{ lib, ... }:
with lib;
{
  imports = [
    ./nemo.nix
  ];

  options.features.utilities = {
    nemo.enable = mkEnableOption "nemo";
    enable = mkEnableOption "utilities" // {
      default = true;
    };
  };
}

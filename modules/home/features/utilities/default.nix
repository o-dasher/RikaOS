{ lib, ... }:
with lib;
{
  imports = [
    ./nemo.nix
  ];

  options.features.utilities = {
    enable = mkEnableOption "utilities";
    nemo.enable = mkEnableOption "nemo";
  };
}

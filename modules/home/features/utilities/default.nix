{ lib, ... }:
{
  imports = [
    ./nemo.nix
    ./trash.nix
  ];

  options.features.utilities.enable = lib.mkEnableOption "utilities features" // {
    default = true;
  };
}

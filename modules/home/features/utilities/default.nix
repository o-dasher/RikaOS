{ lib, ... }:
{
  imports = [
    ./nemo.nix
    ./trash.nix
  ];

  options.features.utilities = {
    enable = lib.mkEnableOption "Utility features." // {
      default = true;
    };
  };
}

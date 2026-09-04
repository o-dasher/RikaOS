{ lib, ... }:
{
  imports = [
    ./setup.nix
  ];

  options.features.nix = {
    enable = lib.mkEnableOption "Nix daemon configuration." // {
      default = true;
    };
  };
}

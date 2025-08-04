{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
  ];

  options.cli = with lib; {
    enable = mkEnableOption "cli";
    hyfetch.enable = mkEnableOption "hyfetch" // {
      default = true;
    };
    fish.enable = (mkEnableOption "fish") // {
      default = true;
    };
  };
}

{ lib, ... }:
{
  imports = [
    ./ghostty.nix
  ];

  options.features.terminal = {
    enable = lib.mkEnableOption "terminal emulators and console environments" // {
      default = true;
    };
  };
}

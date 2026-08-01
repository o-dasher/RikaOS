{ lib, ... }:
{
  imports = [
    ./ghostty.nix
  ];

  options.features.terminal.enable = lib.mkEnableOption "terminal features" // {
    default = true;
  };
}

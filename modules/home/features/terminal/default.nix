{ lib, ... }:
with lib;
{
  imports = [
    ./ghostty.nix
  ];

  options.features.terminal = {
    enable = mkEnableOption "terminal features" // {
      default = true;
    };
  };
}

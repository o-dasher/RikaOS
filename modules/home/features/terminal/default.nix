{ lib, ... }:
with lib;
{
  imports = [
    ./ghostty.nix
  ];

  options.features.terminal = {
    ghostty.enable = mkEnableOption "ghostty";
    enable = mkEnableOption "terminal features" // {
      default = true;
    };
  };
}

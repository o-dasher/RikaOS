{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./ghostty.nix
  ];

  options.terminal = with lib; {
    enable = mkOption { type = lib.types.bool; };
    fish.enable = mkOption {
      type = lib.types.bool;
      default = true;
    };
    ghostty.enable = mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}

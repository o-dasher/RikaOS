{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./ghostty.nix
  ];

  options.terminal = with lib; {
    enable = mkOption { type = lib.types.bool; };
    fish = mkOption { type = lib.types.bool; };
    ghostty = mkOption { type = lib.types.bool; };
  };

  config.terminal = {
    fish.enable = lib.mkDefault true;
    ghostty.enable = lib.mkDefault true;
  };
}

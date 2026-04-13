{ lib, ... }:
with lib;
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
    ./starship.nix
    ./tmux.nix
  ];

  options.features.cli = {
    enable = mkEnableOption "cli features" // {
      default = true;
    };
  };
}

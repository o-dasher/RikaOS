{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
    ./starship.nix
    ./tmux.nix
  ];

  options.features.cli = {
    enable = lib.mkEnableOption "cli features" // {
      default = true;
    };
  };
}

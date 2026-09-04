{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
    ./starship.nix
    ./tmux.nix
  ];

  options.features.cli = {
    enable = lib.mkEnableOption "command-line utilities and shell environments" // {
      default = true;
    };
  };
}

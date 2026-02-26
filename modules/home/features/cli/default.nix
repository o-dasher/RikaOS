{ lib, ... }:
with lib;
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
    ./starship.nix
    ./tmux.nix
    ./gemini.nix
  ];

  options.features.cli = {
    enable = mkEnableOption "cli features" // {
      default = true;
    };
  };
}

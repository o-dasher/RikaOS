{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./hyfetch.nix
    ./starship.nix
    ./tmux.nix
  ];

  options.features.cli = {
    enable = lib.mkEnableOption "CLI features." // {
      default = true;
    };
  };
}

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
    enable = mkEnableOption "cli features";
    fish.enable = mkEnableOption "fish";
    hyfetch.enable = mkEnableOption "hyfetch";
    starship.enable = mkEnableOption "starship";
    tmux.enable = mkEnableOption "tmux";
    gemini.enable = mkEnableOption "gemini-cli";
  };
}

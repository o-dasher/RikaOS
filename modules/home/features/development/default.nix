{ lib, ... }:
with lib;
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./godot.nix
    ./secrets.nix
  ];

  options.features.dev = {
    enable = mkEnableOption "development features";
    direnv.enable = mkEnableOption "direnv";
    git.enable = mkEnableOption "git";
    godot.enable = mkEnableOption "godot";
    secrets.enable = mkEnableOption "secrets";
  };
}

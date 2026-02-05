{ lib, ... }:
with lib;
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./godot.nix
    ./secrets.nix
  ];

  options.features.development = {
    direnv.enable = mkEnableOption "direnv";
    git.enable = mkEnableOption "git";
    godot.enable = mkEnableOption "godot";
    secrets.enable = mkEnableOption "secrets";
    enable = mkEnableOption "development features" // {
      default = true;
    };
  };
}

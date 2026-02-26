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
    enable = mkEnableOption "development features" // {
      default = true;
    };
  };
}

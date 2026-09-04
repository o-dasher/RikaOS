{ lib, ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./godot.nix
    ./secrets.nix
  ];

  options.features.development = {
    enable = lib.mkEnableOption "Development features." // {
      default = true;
    };
  };
}

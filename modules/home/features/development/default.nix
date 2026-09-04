{ lib, ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./godot.nix
    ./secrets.nix
  ];

  options.features.development = {
    enable = lib.mkEnableOption "software development tools (git, direnv, godot, and user secrets)" // {
      default = true;
    };
  };
}

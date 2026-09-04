{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./system-cleanup.nix
    ./xdg.nix
  ];

  options.features.core = {
    enable = lib.mkEnableOption "Core features." // {
      default = true;
    };
  };
}

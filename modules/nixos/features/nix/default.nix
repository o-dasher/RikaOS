{ lib, ... }:
{
  imports = [
    ./setup.nix
  ];

  options.features.nix = {
    enable =
      lib.mkEnableOption "Nix daemon settings, binary caches, and garbage collection configuration"
      // {
        default = true;
      };
  };
}

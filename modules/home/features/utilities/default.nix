{ lib, ... }:
{
  imports = [
    ./nemo.nix
    ./trash.nix
  ];

  options.features.utilities = {
    enable = lib.mkEnableOption "desktop utility applications and automated maintenance timers" // {
      default = true;
    };
  };
}

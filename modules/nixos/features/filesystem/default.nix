{ lib, ... }:
with lib;
{
  imports = [
    ./bitlocker.nix
    ./shared-folders.nix
    ./steam-library.nix
  ];

  options.features.filesystem = {
    enable = mkEnableOption "filesystem features" // {
      default = true;
    };
  };
}

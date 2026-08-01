{ lib, ... }:
{
  imports = [
    ./bitlocker.nix
    ./shared-folders.nix
    ./steam-library.nix
  ];

  options.features.filesystem.enable = lib.mkEnableOption "filesystem features" // {
    default = true;
  };
}

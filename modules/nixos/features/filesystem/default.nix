{ lib, ... }:
{
  imports = [
    ./bitlocker.nix
    ./shared-folders.nix
    ./steam-library.nix
  ];

  options.features.filesystem.enable =
    lib.mkEnableOption "system filesystem features (BitLocker unlock, shared folders, steam library)"
    // {
      default = true;
    };
}

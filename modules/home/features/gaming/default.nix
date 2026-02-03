{ lib, ... }:
{
  imports = [
    ./heroic.nix
    ./minecraft.nix
    ./osu.nix
    ./ps4.nix
    ./steam.nix
  ];

  options.features.gaming.enable = lib.mkEnableOption "Gaming";
}

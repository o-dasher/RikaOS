{ lib, ... }:
{
  imports = [
    ./osu.nix
    ./minecraft.nix
    ./goverlay.nix
    ./heroic.nix
    ./ps4.nix
    ./steam.nix
  ];

  options.features.gaming.enable = lib.mkEnableOption "Gaming";
}

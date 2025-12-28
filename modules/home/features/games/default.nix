{ lib, ... }:
{
  imports = [
    ./osu.nix
    ./minecraft.nix
    ./goverlay.nix
    ./heroic.nix
    ./ps4.nix
    ./lutris.nix
  ];

  options.games.enable = lib.mkEnableOption "Games";
}

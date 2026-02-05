{ lib, ... }:
with lib;
{
  imports = [
    ./heroic.nix
    ./mangohud.nix
    ./minecraft.nix
    ./osu.nix
    ./ps4.nix
    ./steam.nix
  ];

  options.features.gaming = {
    heroic.enable = mkEnableOption "heroic";
    mangohud.enable = mkEnableOption "mangohud";
    minecraft.enable = mkEnableOption "minecraft";
    osu.enable = mkEnableOption "osu-lazer";
    ps4.enable = mkEnableOption "ps4";
    steam.enable = mkEnableOption "Steam";
    enable = mkEnableOption "Gaming" // {
      default = true;
    };
  };
}

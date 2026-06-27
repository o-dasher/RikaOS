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
    enable = mkEnableOption "Gaming" // {
      default = true;
    };
  };
}

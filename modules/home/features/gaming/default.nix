{ lib, ... }:
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
    enable = lib.mkEnableOption "gaming applications and launcher integrations" // {
      default = true;
    };
  };
}

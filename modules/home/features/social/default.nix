{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./zapzap.nix
  ];

  options.features.social = {
    enable = lib.mkEnableOption "social features";
    zapzap.enable = lib.mkEnableOption "ZapZap";
    discord = {
      enable = lib.mkEnableOption "Discord with Krisp";
      enableKrispPatch = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the Krisp noise suppression patch for Discord";
      };
    };
  };
}

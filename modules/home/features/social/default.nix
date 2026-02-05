{ lib, ... }:
with lib;
{
  imports = [
    ./discord.nix
    ./zapzap.nix
  ];

  options.features.social = {
    enable = mkEnableOption "social features";
    zapzap.enable = mkEnableOption "ZapZap";
    discord = {
      enable = mkEnableOption "Discord with Krisp";
      enableKrispPatch = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the Krisp noise suppression patch for Discord";
      };
    };
  };
}

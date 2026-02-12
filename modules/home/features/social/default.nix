{ lib, ... }:
with lib;
{
  imports = [
    ./discord.nix
    ./email.nix
    ./zapzap.nix
  ];

  options.features.social = {
    email.enable = mkEnableOption "declarative email accounts";
    zapzap.enable = mkEnableOption "ZapZap";
    discord = {
      enable = mkEnableOption "Discord with Krisp";
      enableKrispPatch = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the Krisp noise suppression patch for Discord";
      };
    };
    enable = mkEnableOption "social features" // {
      default = true;
    };
  };
}

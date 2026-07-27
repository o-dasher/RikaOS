{ lib, ... }:
with lib;
{
  imports = [
    ./discord.nix
    ./email.nix
    ./zapzap.nix
  ];

  options.features.social = {
    enable = mkEnableOption "social features" // {
      default = true;
    };
  };
}

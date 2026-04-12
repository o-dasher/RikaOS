{ lib, ... }:
with lib;
{
  imports = [
    ./discord.nix
    ./email.nix
  ];

  options.features.social = {
    enable = mkEnableOption "social features" // {
      default = true;
    };
  };
}

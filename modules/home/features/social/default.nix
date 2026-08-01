{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./email.nix
    ./zapzap.nix
  ];

  options.features.social.enable = lib.mkEnableOption "social features" // {
    default = true;
  };
}

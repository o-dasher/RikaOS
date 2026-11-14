{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./email.nix
    ./signal.nix
    ./zapfast.nix
  ];

  options.features.social.enable = lib.mkEnableOption "Social features." // {
    default = true;
  };
}

{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./email.nix
    ./signal.nix
  ];

  options.features.social = {
    enable = lib.mkEnableOption "Social features." // {
      default = true;
    };
  };
}

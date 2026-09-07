{ lib, ... }:
{
  imports = [
    ./discord.nix
    ./email.nix
  ];

  options.features.social = {
    enable = lib.mkEnableOption "Social features." // {
      default = true;
    };
  };
}

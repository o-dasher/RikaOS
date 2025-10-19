{ lib, config, pkgs, inputs, ... }:
{
  options.games.osu.enable = lib.mkEnableOption "osu-lazer";

  config = lib.mkIf config.games.osu.enable {
    home.packages = [
      inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.osu-lazer-bin
    ];
  };
}

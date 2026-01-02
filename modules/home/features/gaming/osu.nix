{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.features.gaming.osu.enable = lib.mkEnableOption "osu-lazer";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.osu.enable) {
    home.packages = [
      (config.features.gaming.gamescope.wrapDefault
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
      )
    ];
  };
}

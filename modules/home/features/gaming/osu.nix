{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.osu;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [
      inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
    ];
  };
}

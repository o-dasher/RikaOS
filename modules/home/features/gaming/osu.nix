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
    home = {
      sessionVariables.OSU_SDL3 = 1;
      packages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
      ];
    };
  };
}

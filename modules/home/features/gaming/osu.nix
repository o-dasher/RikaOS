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
  options.features.gaming.osu.enable = mkEnableOption "osu-lazer";

  config = mkIf (modCfg.enable && cfg.enable) {
    home = {
      sessionVariables.OSU_SDL3 = 1;
      packages = with inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}; [
        osu-lazer-bin
      ];
    };
  };
}

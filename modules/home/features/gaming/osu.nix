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
{
  options.features.gaming.osu.enable = lib.mkEnableOption "osu-lazer";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home = {
      sessionVariables.OSU_SDL3 = 1;
      packages = [
        (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
          pipewire_latency = "32/48000";
        })
      ];
    };
  };
}

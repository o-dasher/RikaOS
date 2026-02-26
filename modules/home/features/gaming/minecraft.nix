{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.minecraft;
in
with lib;
{
  options.features.gaming.minecraft.enable = mkEnableOption "minecraft";

  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [
      (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-jre-bin
          temurin-jre-bin-17
          temurin-jre-bin-8
        ];
      })
    ];
  };
}

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
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-jre-bin
          temurin-jre-bin-17
          temurin-jre-bin-8
        ];
      };
    };
  };
}

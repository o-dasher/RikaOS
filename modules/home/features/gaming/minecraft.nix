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
{
  options.features.gaming.minecraft.enable =
    lib.mkEnableOption "Prism Launcher Minecraft client with Temurin JRE runtime packages";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-jre-bin-25
          temurin-jre-bin-21
          temurin-jre-bin-17
          temurin-jre-bin-8
        ];
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.gaming.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.minecraft.enable) {
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

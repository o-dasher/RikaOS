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
        jdks = [
          pkgs.temurin-bin-21
        ];
      })
    ];
  };
}

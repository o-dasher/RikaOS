{ lib, config, pkgs, ... }:
{
  options.games.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf (config.games.enable && config.games.minecraft.enable) {
    home.packages = [
      (pkgs.prismlauncher.override {
        jdks = [
          pkgs.temurin-bin-21
        ];
      })
    ];
  };
}

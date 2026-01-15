{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.features.gaming.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.minecraft.enable) {
    home.packages =
      let
        overrides = {
          jdks = with pkgs; [
            temurin-jre-bin
            temurin-jre-bin-17
            temurin-jre-bin-8
          ];
        };
      in
      [
        (inputs.elyprism-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default.override overrides)
      ];
  };
}

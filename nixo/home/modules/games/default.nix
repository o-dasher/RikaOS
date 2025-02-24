{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games = with lib; {
    enable = mkEnableOption "games";
    minecraft = {
      enable = mkEnableOption "minecraft";
    };
  };

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      heroic
      mangohud
      goverlay
      (lib.mkIf config.games.minecraft.enable (
        prismlauncher.override {
          jdks = [
            temurin-bin-21
          ];
        }
      ))
    ];
  };
}

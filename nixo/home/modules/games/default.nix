{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games = with lib; {
    enable = mkEnableOption "games";
    osu.enable = mkEnableOption "osu-lazer";
    minecraft.enable = mkEnableOption "minecraft";
  };

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      mangohud
      goverlay
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamescope
        ];
      })
      (lib.mkIf config.games.osu.enable osu-lazer-bin)
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

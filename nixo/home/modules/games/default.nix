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
      (lib.mkIf config.games.minecraft.enable (
        prismlauncher.override {
          jdks = [
            openjdk21
          ];
        }
      ))
    ];
  };
}

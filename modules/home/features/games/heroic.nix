{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf (config.games.enable && config.games.heroic.enable) {
    home.packages = [
      (pkgs.heroic.override {
        extraPkgs =
          pkgs: with pkgs; [
            gamescope
            gamemode
          ];
      })
    ];
  };
}

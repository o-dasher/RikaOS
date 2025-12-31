{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.heroic.enable) {
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

{ lib, config, pkgs, ... }:
{
  options.games.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf config.games.heroic.enable {
    home.packages = [
      (pkgs.heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamescope
        ];
      })
    ];
  };
}

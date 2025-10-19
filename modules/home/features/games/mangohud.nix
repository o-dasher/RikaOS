{ lib, config, pkgs, ... }:
{
  options.games.mangohud.enable = lib.mkEnableOption "mangohud";

  config = lib.mkIf config.games.mangohud.enable {
    home.packages = [ pkgs.mangohud ];
  };
}

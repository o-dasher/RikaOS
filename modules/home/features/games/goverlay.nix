{ lib, config, pkgs, ... }:
{
  options.games.goverlay.enable = lib.mkEnableOption "goverlay";

  config = lib.mkIf config.games.goverlay.enable {
    home.packages = [ pkgs.goverlay ];
  };
}

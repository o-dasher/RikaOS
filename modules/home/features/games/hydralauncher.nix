{ lib, config, pkgs, ... }:
{
  options.games.hydralauncher.enable = lib.mkEnableOption "hydralauncher";

  config = lib.mkIf config.games.hydralauncher.enable {
    home.packages = [ pkgs.hydralauncher ];
  };
}

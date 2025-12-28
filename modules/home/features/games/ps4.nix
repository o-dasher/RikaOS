{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games.ps4.enable = lib.mkEnableOption "ps4";

  config = lib.mkIf (config.games.enable && config.games.ps4.enable) {
    home.packages = [
      pkgs.shadps4
    ];
  };
}

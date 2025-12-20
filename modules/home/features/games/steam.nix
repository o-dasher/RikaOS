{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.games.steam.enable {
    home.packages = [
      pkgs.steam
    ];
  };
}

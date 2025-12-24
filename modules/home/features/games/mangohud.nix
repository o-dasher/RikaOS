{
  lib,
  config,
  ...
}:
{
  options.games.mangohud.enable = lib.mkEnableOption "mangohud";

  config = lib.mkIf config.games.mangohud.enable {
    programs.mangohud.enable = true;
  };
}

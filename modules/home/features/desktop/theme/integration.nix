{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.theme;
  systemThemeEnabled =
    (osConfig.theme.cirnold.enable or false) || (osConfig.theme.graduation.enable or false);
in
{
  config = lib.mkIf systemThemeEnabled {
    stylix = {
      targets.nixcord.enable = false;
      targets.zen-browser.profileNames = [ "default" ];
    };
  };
}

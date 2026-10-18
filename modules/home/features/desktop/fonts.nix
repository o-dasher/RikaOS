{
  lib,
  config,
  ...
}:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.fonts;
in
{
  options.features.desktop.fonts.enable = lib.mkEnableOption "Desktop fonts." // {
    default = true;
  };

  config = lib.mkIf (desktopCfg.enable && modCfg.enable) {
    fonts.fontconfig.enable = true;
  };
}

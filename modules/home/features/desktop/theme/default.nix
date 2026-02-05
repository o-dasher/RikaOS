{
  lib,
  config,
  options,
  themeLib,
  ...
}:
let
  desktopCfg = config.features.desktop or null;
  modCfg = if desktopCfg == null then null else desktopCfg.theme;
  hasStylix = options ? stylix;
in
{
  imports = [
    ../../../../lib
  ];

  config =
    lib.mkIf (hasStylix && modCfg != null && desktopCfg.enable && modCfg.enable) {
      stylix = {
        icons.enable = true;
        targets = {
          nixcord.enable = false;
          zen-browser.profileNames = [ "default" ];
        };
        cursor = themeLib.cursor;
      };
    };
}

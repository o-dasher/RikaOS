{
  lib,
  config,
  options,
  themeLib,
  ...
}:
let
  modCfg = config.features.desktop.theme;
  hasStylix = options ? stylix;
in
{
  imports = [
    ../../../../lib
  ];

  config = lib.optionalAttrs hasStylix (
    lib.mkIf (config.features.desktop.enable && modCfg.enable) {
      stylix = {
        icons.enable = true;
        cursor = themeLib.cursor;
        targets = {
          nixcord.enable = false;
          zen-browser.profileNames = [ "default" ];
        };
      };
    }
  );
}

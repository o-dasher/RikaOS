{
  lib,
  options,
  themeLib,
  ...
}:
let
  hasStylix = options ? stylix;
in
{
  imports = [
    ../../../../lib
  ];

  config = lib.optionalAttrs hasStylix {
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

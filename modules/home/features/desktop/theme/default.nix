{
  pkgs,
  lib,
  options,
  ...
}:
let
  hasStylix = options ? stylix;
in
{
  imports = [
    ../../../../common/theme
  ];

  config = lib.optionalAttrs hasStylix {
    stylix = {
      icons.enable = true;
      targets = {
        nixcord.enable = false;
        zen-browser.profileNames = [ "default" ];
      };
      cursor = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 16;
      };
    };
  };
}

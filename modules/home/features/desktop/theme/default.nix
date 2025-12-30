{ pkgs, ... }:
let
  cursorName = "BreezeX-RosePine-Linux";
  cursorPackage = pkgs.rose-pine-cursor;
in
{
  imports = [
    ../../../../common/theme
  ];

  home.pointerCursor = {
    name = cursorName;
    package = cursorPackage;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = cursorName;
      package = cursorPackage;
    };
  };

  stylix = {
    icons.enable = true;
    targets.nixcord.enable = false;
    targets.zen-browser.profileNames = [ "default" ];
  };
}

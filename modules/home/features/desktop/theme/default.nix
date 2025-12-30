{ pkgs, ... }:
let
in
{
  imports = [
    ../../../../common/theme
  ];

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
}

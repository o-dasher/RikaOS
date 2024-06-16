{ pkgs, ... }:
{
  stylix.image = ../../../../assets/Wallpapers/rikamoon.jpg;
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}

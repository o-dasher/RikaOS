{ pkgs, ... }:
{
  stylix.image = ../../../../assets/Wallpapers/ryo.png;
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}

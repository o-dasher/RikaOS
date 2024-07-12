{ pkgs, ... }:
{
  stylix.image = ../../../../assets/Wallpapers/flan.jpg;
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}

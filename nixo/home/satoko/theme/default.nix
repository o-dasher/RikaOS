{ pkgs, ... }:
{
  stylix.image = ../../../../assets/Wallpapers/graduation.png;
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}

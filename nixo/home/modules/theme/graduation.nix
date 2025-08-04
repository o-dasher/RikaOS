{ pkgs, ... }:
{
  stylix = {
    image = ../../../../../assets/Wallpapers/graduation.png;
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";
    iconTheme =
      let
        name = "WhiteSur";
      in
      {
        package = pkgs.whitesur-icon-theme;
        dark = name;
        light = name;
      };
    opacity =
      let
        v = 0.9;
      in
      {
        popups = v;
        terminal = v;
      };
  };
}

{ pkgs, lib, ... }:
let
  brightness = toString (-10);
in
{
  stylix = {
    image = pkgs.runCommand "dimmed-background.png" { } ''
      ${lib.getExe' pkgs.imagemagick "magick"} "${../../../assets/Wallpapers/cirnold.png}" -brightness-contrast ${brightness},0 $out
    '';
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
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
    opacity = {
      popups = 1.;
      terminal = 0.95;
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.theme.cirnold;
  brightness = toString (-10);
  name = "WhiteSur";
in
{
  options.theme.cirnold.enable = lib.mkEnableOption "Cirnold theme";

  config = lib.mkIf cfg.enable {
    stylix = {
      image = pkgs.runCommand "dimmed-background.png" { } ''
        ${lib.getExe' pkgs.imagemagick "magick"} "${../../../../assets/Wallpapers/cirnold.png}" -brightness-contrast ${brightness},0 $out
      '';
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      iconTheme = {
        package = pkgs.whitesur-icon-theme;
        dark = name;
        light = name;
      };
      opacity = {
        popups = 1.0;
        terminal = 0.95;
      };
    };
  };
}

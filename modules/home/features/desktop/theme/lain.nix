{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  cfg = config.theme;
  brightness = if config.stylix.polarity == "dark" then "-15" else "10";
in
{
  config = lib.mkIf config.theme.lain.enable (
    lib.optionalAttrs (options ? stylix) {
      stylix.image = pkgs.runCommand "dimmed-wallpaper.png" { } ''
        ${lib.getExe' pkgs.imagemagick "magick"} "${../../../../../assets/Wallpapers/lain.jpg}" -brightness-contrast ${brightness},0 $out
      '';
    }
  );
}

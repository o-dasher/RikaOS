{
  lib,
  pkgs,
  config,
  ...
}:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.fonts;
in
{
  options.features.desktop.fonts.enable = lib.mkEnableOption "Desktop fonts." // {
    default = true;
  };

  config = lib.mkIf (desktopCfg.enable && modCfg.enable) {
    fonts.fontconfig.enable = true;

    # Shallow XDG link so font scanners with bounded depth (e.g. fastframe-fonts depth 4) find CJK glyphs.
    xdg.dataFile."fonts/noto-cjk/NotoSansCJK-Regular.ttc".source =
      "${pkgs.noto-fonts-cjk-sans-static}/share/fonts/opentype/noto-cjk/NotoSansCJK-Regular.ttc";
  };
}

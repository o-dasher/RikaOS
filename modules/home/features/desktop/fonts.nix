{
  lib,
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

    # Map every user font package flatly so bounded-depth scanners discover all installed fonts.
    xdg.dataFile."fonts/nix".source = config.rika.utils.mkFlatFonts {
      name = "home-flat-fonts";
      pkgsList = config.home.packages;
      subPath = "";
    };
  };
}

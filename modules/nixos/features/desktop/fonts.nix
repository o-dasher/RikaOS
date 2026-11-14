{ lib, config, ... }:
let
  cfg = config.features.desktop.fonts;
in
{
  options.features.desktop.fonts.enable = lib.mkEnableOption "Flat system font mapping.";

  config = lib.mkIf cfg.enable {
    environment = {
      pathsToLink = [ "/share/fonts" ];
      systemPackages = [
        (config.rika.utils.mkFlatFonts {
          name = "system-flat-fonts";
          pkgsList = config.fonts.packages;
        })
      ];
    };
  };
}

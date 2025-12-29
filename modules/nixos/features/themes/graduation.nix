{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.theme.graduation;
  name = "WhiteSur";
in
{
  options.theme.graduation.enable = lib.mkEnableOption "Graduation theme";

  config = lib.mkIf cfg.enable {
    stylix = {
      image = ../../../../assets/Wallpapers/graduation.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      iconTheme = {
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
  };
}

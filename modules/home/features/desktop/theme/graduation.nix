{ pkgs, lib, config, options, ... }:
{
  config = lib.mkIf config.theme.graduation.enable (lib.optionalAttrs (options ? stylix) {
    stylix = {
      image = ../../../../../assets/Wallpapers/graduation.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
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
  });
}

{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  hasStylix = options ? stylix;
  isHomeManager = options ? home;
in
{
  options.theme = {
    cirnold.enable = lib.mkEnableOption "Cirnold theme";
    graduation.enable = lib.mkEnableOption "Graduation theme";
    rose-pine.enable = lib.mkEnableOption "Rose Pine theme";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.theme.cirnold.enable && hasStylix) {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        image = pkgs.runCommand "dimmed-background.png" { } ''
          ${lib.getExe' pkgs.imagemagick "magick"} "${../../../assets/Wallpapers/cirnold.png}" -brightness-contrast -10,0 $out
        '';
        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          dark = "WhiteSur";
          light = "WhiteSur";
        };
        opacity = {
          popups = 1.0;
          terminal = 0.95;
        };
      };
    })

    (lib.mkIf (config.theme.graduation.enable && hasStylix) {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
        image = ../../../assets/Wallpapers/graduation.png;
        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          dark = "WhiteSur";
          light = "WhiteSur";
        };
        opacity = {
          popups = 0.9;
          terminal = 0.9;
        };
      };
    })

    (lib.mkIf (config.theme.rose-pine.enable && hasStylix) {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
        image = ../../../assets/Wallpapers/lain.jpg;
        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          dark = "WhiteSur";
          light = "WhiteSur";
        };
        opacity = {
          popups = 0.9;
          terminal = 0.9;
        };
      };
    })

    # Home-manager specific overrides (only evaluated in home-manager context)
    (lib.optionalAttrs (isHomeManager && hasStylix) (
      lib.mkIf
        (config.theme.cirnold.enable || config.theme.graduation.enable || config.theme.rose-pine.enable)
        {
          stylix = {
            targets.nixcord.enable = false;
            targets.zen-browser.profileNames = [ "default" ];
          };
        }
    ))
  ];
}

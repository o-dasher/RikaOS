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

  config = lib.mkMerge (
    lib.optionals hasStylix [
      (lib.mkIf config.theme.cirnold.enable {
        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
          image = pkgs.runCommand "dimmed-background.png" { } ''
            ${lib.getExe' pkgs.imagemagick "magick"} "${../../../assets/Wallpapers/cirnold.png}" -brightness-contrast -10,0 $out
          '';
          icons = {
            package = pkgs.whitesur-icon-theme;
            dark = "WhiteSur-dark";
            light = "WhiteSur-light";
          };
          opacity = {
            popups = 1.0;
            terminal = 0.95;
          };
        };
      })

      (lib.mkIf config.theme.graduation.enable {
        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
          image = ../../../assets/Wallpapers/graduation.png;
          icons = {
            package = pkgs.adwaita-icon-theme;
            dark = "Adwaita";
            light = "Adwaita";
          };
          opacity = {
            popups = 0.9;
            terminal = 0.9;
          };
        };
      })

      (lib.mkIf config.theme.rose-pine.enable {
        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
          image = ../../../assets/Wallpapers/lain.jpg;
          icons = {
            package = pkgs.whitesur-icon-theme;
            dark = "WhiteSur-dark";
            light = "WhiteSur-light";
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
            dconf.enable = true;
            home.pointerCursor = {
              name = "BreezeX-RosePine-Linux";
              hyprcursor.enable = true;
              package = pkgs.rose-pine-cursor;
            };
            gtk = {
              enable = true;
              cursorTheme = {
                name = config.home.pointerCursor.name;
                package = config.home.pointerCursor.package;
              };
              iconTheme = {
                name = config.stylix.icons.dark;
                package = config.stylix.icons.package;
              };
            };
            stylix = {
              targets.nixcord.enable = false;
              targets.zen-browser.profileNames = [ "default" ];
            };
          }
      ))
    ]
  );
}

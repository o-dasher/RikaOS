{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  themes = {
    cirnold = {
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
        popups = 0.9;
        terminal = 0.9;
      };
    };

    graduation = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      image = ../../../assets/Wallpapers/graduation.png;
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

    lain = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      image = ../../../assets/Wallpapers/lain.jpg;
    };
  };

  mkStylixConfig =
    themeConfig:
    let
      validKeys = [
        "base16Scheme"
        "image"
        "icons"
        "opacity"
        "polarity"
      ];
    in
    {
      enable = true;
      polarity = themeConfig.polarity or "dark";
    }
    // (lib.filterAttrs (n: v: lib.elem n validKeys) themeConfig);
in
{
  options.theme = lib.mapAttrs (name: _: {
    enable = lib.mkEnableOption "${name} theme";
  }) themes;

  config =
    let
      hasStylix = options ? stylix;
      isHomeManager = options ? home.stateVersion;
      themeNames = lib.attrNames themes;
    in
    lib.mkMerge (
      map (
        themeName:
        lib.mkIf config.theme.${themeName}.enable (
          lib.mkMerge [
            # 1. Apply Stylix base settings
            (lib.optionalAttrs hasStylix {
              stylix = mkStylixConfig themes.${themeName};
            })

            # 2. Home-manager specific overrides (GTK, Cursors, and Targets)
            (lib.optionalAttrs (isHomeManager && hasStylix) (
              let
                cursorName = "BreezeX-RosePine-Linux";
                cursorPackage = pkgs.rose-pine-cursor;
              in
              {
                home.pointerCursor = {
                  name = cursorName;
                  package = cursorPackage;
                };

                gtk = {
                  enable = true;
                  cursorTheme = {
                    name = cursorName;
                    package = cursorPackage;
                  };
                };

                stylix = {
                  icons.enable = true;
                  targets.nixcord.enable = false;
                  targets.zen-browser.profileNames = [ "default" ];
                };
              }
            ))
          ]
        )
      ) themeNames
    );
}

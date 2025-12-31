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
      themeNames = lib.attrNames themes;
    in
    lib.mkMerge (
      map (
        themeName:
        lib.mkIf config.theme.${themeName}.enable (
          lib.mkMerge [
            (lib.optionalAttrs hasStylix {
              stylix = mkStylixConfig themes.${themeName};
            })
          ]
        )
      ) themeNames
    );
}

{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  themes =
    let
      mkBase =
        base: theme:
        {
          base16Scheme = "${pkgs.base16-schemes}/share/themes/${base}.yaml";
        }
        // theme;

      mkBaseWhiteSur =
        base: theme:
        mkBase base (
          lib.recursiveUpdate {
            icons = {
              package = pkgs.whitesur-icon-theme;
              dark = "WhiteSur-dark";
              light = "WhiteSur-light";
            };
            opacity = {
              popups = 0.9;
              terminal = 0.9;
              desktop = 0.6;
            };
          } theme
        );
    in
    {
      graduation = mkBaseWhiteSur "rose-pine" {
        image = ../../../assets/Wallpapers/graduation.png;
      };

      lain-realism = mkBaseWhiteSur "rose-pine" {
        image = ../../../assets/Wallpapers/lainrealism.jpg;
      };

      lain = mkBase "rose-pine" {
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
      ++ [
        {
          _module.args.themeLib = {
            cursor = {
              name = "BreezeX-RosePine-Linux";
              package = pkgs.rose-pine-cursor;
              size = 16;
            };
          };
        }
      ]
    );
}

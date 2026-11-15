{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  mkTheme = image: {
    inherit image;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    icons = {
      package = pkgs.whitesur-icon-theme;
      dark = "WhiteSur-dark";
      light = "WhiteSur-light";
    };
    opacity = {
      popups = 0.90;
      terminal = 0.9;
      desktop = 0.6;
    };
  };

  themes = {
    cirnosunset = mkTheme ../../assets/Wallpapers/cirnosunset.jpg;
    lucky-star = mkTheme ../../assets/Wallpapers/luckystar.png;
    graduation = mkTheme ../../assets/Wallpapers/graduation.png;
    lain = mkTheme ../../assets/Wallpapers/lain.jpg;
  };

  mkStylix =
    cfg:
    {
      enable = true;
      autoEnable = false;
      # Stylix tracks master while NixOS and Home Manager stay on stable.
      enableReleaseChecks = false;
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        sizes = {
          desktop = 9;
          applications = 12;
          popups = 12;
        };
      };
    }
    // cfg;
in
{
  options.features.desktop.theme =
    (lib.mapAttrs (name: _: {
      enable = lib.mkEnableOption "The ${name} theme.";
    }) themes)
    // {
      enable = lib.mkEnableOption "Desktop theming via Stylix." // {
        default = true;
      };
    };

  config = lib.mkMerge (
    [
      {
        _module.args.themeLib.cursor = {
          name = "BreezeX-RosePine-Linux";
          package = pkgs.rose-pine-cursor;
          size = 16;
        };
      }
    ]
    ++ map (
      name:
      lib.mkIf (config.features.desktop.theme.enable && config.features.desktop.theme.${name}.enable) (
        lib.optionalAttrs (options ? stylix) { stylix = mkStylix themes.${name}; }
      )
    ) (lib.attrNames themes)
  );
}

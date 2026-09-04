{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.fonts;
in
{
  options.features.desktop.fonts.enable =
    lib.mkEnableOption "system fonts (JetBrainsMono Nerd Font, Noto Sans/Serif, and CJK fonts)"
    // {
      default = true;
    };

  config = lib.mkIf (desktopCfg.enable && modCfg.enable) (
    lib.mkMerge [
      (lib.optionalAttrs (options ? stylix) {
        stylix.fonts = {
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
      })
      {
        fonts.fontconfig.enable = true;
      }
    ]
  );
}

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
with lib;
{
  config = mkIf (desktopCfg.enable && modCfg.enable) (
    mkMerge [
      (optionalAttrs (options ? stylix) {
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
        home.packages = with pkgs; [
          # Coding / Terminal
          nerd-fonts.fira-mono

          # Essential for Web & Documents
          noto-fonts-cjk-sans
          liberation_ttf
          dejavu_fonts
        ];
      }
    ]
  );
}

{
  lib,
  config,
  options,
  themeLib,
  ...
}:
let
  modCfg = config.features.desktop.theme;
  hasStylix = options ? stylix;
in
{
  config = lib.optionalAttrs hasStylix (
    lib.mkIf (config.features.desktop.enable && modCfg.enable) {
      gtk.colorScheme = config.stylix.polarity;
      stylix = {
        inherit (themeLib) cursor;
        icons.enable = true;
        targets = {
          bat.enable = true;
          btop.enable = true;
          fish.enable = true;
          font-packages.enable = true;
          fontconfig.enable = true;
          fzf.enable = true;
          ghostty.enable = true;
          gtk.enable = true;
          lazygit.enable = true;
          mangohud.enable = true;
          mpv.enable = true;
          nixcord.enable = false;
          noctalia.enable = true;
          qt.enable = true;
          starship.enable = true;
          tmux.enable = true;
          yazi.enable = true;
          zathura.enable = true;
          zed.enable = true;
          hyprland = {
            enable = true;
            hyprpaper.enable = false;
          };
          kde = {
            enable = true;
            useWallpaper = false;
          };
          librewolf = {
            enable = true;
            profileNames = [ "default" ];
          };
        };
      };
    }
  );
}

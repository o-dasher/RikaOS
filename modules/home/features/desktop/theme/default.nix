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
      stylix = {
        inherit (themeLib) cursor;
        icons.enable = true;
        targets = {
          bat.enable = true;
          btop.enable = true;
          feh.enable = true;
          fish.enable = true;
          font-packages.enable = true;
          fontconfig.enable = true;
          fzf.enable = true;
          ghostty.enable = true;
          gtk.enable = true;
          hyprland.enable = true;
          kde.enable = true;
          lazygit.enable = true;
          mangohud.enable = true;
          mpv.enable = true;
          nixcord.enable = false;
          qt.enable = true;
          starship.enable = true;
          swaylock.enable = true;
          tmux.enable = true;
          wayle.enable = true;
          yazi.enable = true;
          zathura.enable = true;
          zed.enable = true;
          librewolf = {
            enable = true;
            profileNames = [ "default" ];
          };
        };
      };
    }
  );
}

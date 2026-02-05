{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.wayland;
in
{
  imports = [
    ./walker.nix
    ./mako.nix
    ./waybar.nix
  ];

  config =
    mkIf (desktopCfg.enable && modCfg.enable) {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };

    home.sessionVariables = {
      # Electron
      NIXOS_OZONE_WL = "1";

      # SDL
      OSU_SDL3 = "1";
      SDL_VIDEODRIVER = "wayland";

      # Fixes ghostty dead keys.
      GTK_IM_MODULE = "simple";
    };
  };
}

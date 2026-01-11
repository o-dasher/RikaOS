{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./walker.nix
    ./mako.nix
    ./waybar.nix
  ];

  options.features.desktop.wayland.enable = lib.mkEnableOption "Wayland base integration";
  config = lib.mkIf config.features.desktop.wayland.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];

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

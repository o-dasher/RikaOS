{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.wayland.enable = lib.mkEnableOption "Wayland base integration" // {
    default = true;
  };

  config = lib.mkIf config.desktop.wayland.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    home.sessionVariables = {
      # app2unit slice configuration
      APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";

      # SDL
      OSU_SDL3 = "1";
      SDL_VIDEODRIVER = "wayland";

      # Fixes ghostty dead keys.
      GTK_IM_MODULE = "simple";
    };
  };
}

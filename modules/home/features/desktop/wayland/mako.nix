{ config, lib, ... }:
{
  options.features.desktop.wayland.mako.enable = (lib.mkEnableOption "mako") // {
    default = true;
  };

  config.services.mako =
    lib.mkIf (config.features.desktop.wayland.enable && config.features.desktop.wayland.mako.enable)
      {
        enable = true;
        settings = {
          default-timeout = 3000;
          "mode=dnd".invisible = 1;
        };
      };
}

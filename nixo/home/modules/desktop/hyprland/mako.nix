{ config, lib, ... }:
{
  options.desktop.hyprland.mako.enable = (lib.mkEnableOption "mako") // {
    default = true;
  };

  config.services.mako =
    lib.mkIf (config.desktop.hyprland.enable && config.desktop.hyprland.mako.enable)
      {
        enable = true;
        settings = {
          default-timeout = 3000;
        };
      };
}

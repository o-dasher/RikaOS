{ config, lib, ... }:
{
  options.features.desktop.hyprland.mako.enable = (lib.mkEnableOption "mako") // {
    default = true;
  };

  config.services.mako =
    lib.mkIf (config.features.desktop.hyprland.enable && config.features.desktop.hyprland.mako.enable)
      {
        enable = true;
        settings = {
          default-timeout = 3000;
        };
      };
}

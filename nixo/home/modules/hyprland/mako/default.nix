{ config, lib, ... }:
{
  services.mako = lib.mkIf (config.hyprland.enable && config.hyprland.mako.enable) {
    enable = true;
    defaultTimeout = 3000;
  };
}

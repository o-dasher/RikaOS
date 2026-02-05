{ config, lib, ... }:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.wayland;
  cfg = modCfg.mako;
in
with lib;
{
  config.services.mako =
    mkIf (desktopCfg.enable && modCfg.enable && cfg.enable) {
      enable = true;
      settings = {
        default-timeout = 3000;
        "mode=dnd".invisible = 1;
      };
    };
}

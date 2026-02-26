{ config, lib, ... }:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.wayland;
  cfg = modCfg.mako;
in
with lib;
{
  options.features.desktop.wayland.mako.enable = (mkEnableOption "mako") // {
    default = true;
  };

  config.services.mako = mkIf (desktopCfg.enable && modCfg.enable && cfg.enable) {
    enable = true;
    settings = {
      default-timeout = 3000;
      "mode=dnd".invisible = 1;
    };
  };
}

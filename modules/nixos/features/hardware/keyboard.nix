{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.features.hardware;
  cfg = modCfg.keyboard;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    hardware.keyboard.qmk.enable = true;
    services.udev.packages = [ pkgs.via ];
  };
}

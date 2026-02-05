{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.bluetooth;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}

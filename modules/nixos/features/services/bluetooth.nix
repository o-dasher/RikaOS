{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.bluetooth;
in
{
  options.features.services.bluetooth.enable = lib.mkEnableOption "Bluetooth support.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}

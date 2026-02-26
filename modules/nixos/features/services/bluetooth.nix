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
  options.features.services.bluetooth.enable = mkEnableOption "bluetooth";

  config = mkIf (modCfg.enable && cfg.enable) {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}

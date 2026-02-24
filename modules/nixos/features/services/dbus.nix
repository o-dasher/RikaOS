{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.dbus;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    services.dbus.implementation = "broker";
  };
}

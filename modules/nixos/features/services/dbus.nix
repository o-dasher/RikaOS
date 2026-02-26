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
  options.features.services.dbus.enable = mkEnableOption "dbus";

  config = mkIf (modCfg.enable && cfg.enable) {
    services.dbus.implementation = "broker";
  };
}

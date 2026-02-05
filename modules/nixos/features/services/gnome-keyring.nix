{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.gnome-keyring;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
  };
}

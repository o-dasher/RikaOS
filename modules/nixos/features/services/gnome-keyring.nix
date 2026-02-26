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
  options.features.services.gnome-keyring.enable = mkEnableOption "gnome keyring";

  config = mkIf (modCfg.enable && cfg.enable) {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
  };
}

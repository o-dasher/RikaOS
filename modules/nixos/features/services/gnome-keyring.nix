{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.gnome-keyring;
in
{
  options.features.services.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
  };
}

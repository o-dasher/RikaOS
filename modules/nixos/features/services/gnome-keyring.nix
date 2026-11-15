{
  lib,
  config,
  ...
}:
let
  cfg = config.features.services.gnome-keyring;
in
{
  options.features.services.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring.";

  config = lib.mkIf cfg.enable {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
  };
}

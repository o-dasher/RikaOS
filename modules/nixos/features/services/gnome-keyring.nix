{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.services.gnome-keyring = {
    enable = lib.mkEnableOption "gnome keyring";
  };

  config = lib.mkIf config.features.services.gnome-keyring.enable {
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
  };
}

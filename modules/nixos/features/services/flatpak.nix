{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.flatpak;
in
with lib;
{
  options.features.services.flatpak.enable = mkEnableOption "Flatpak support";

  config = mkIf (modCfg.enable && cfg.enable) {
    services.flatpak = {
      enable = true;
      update.onActivation = true;
    };

    # Required for Flatpak apps to access system fonts and icons
    fonts.fontDir.enable = true;

    # XDG portal is needed for Flatpak sandbox integration
    xdg.portal.enable = true;
  };
}

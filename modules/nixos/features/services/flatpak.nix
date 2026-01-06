{
  lib,
  config,
  ...
}:
{
  options.features.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak support";
  };

  config = lib.mkIf config.features.services.flatpak.enable {
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

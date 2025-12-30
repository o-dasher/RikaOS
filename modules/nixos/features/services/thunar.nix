{
  lib,
  config,
  ...
}:
{
  options.features.services.thunar = {
    enable = lib.mkEnableOption "thunar";
  };

  config = lib.mkIf config.features.services.thunar.enable {
    programs = {
      thunar.enable = true;
      xfconf.enable = true;
    };
    services = {
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # Thumbnail support for images
    };
  };
}

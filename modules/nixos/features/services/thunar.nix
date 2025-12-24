{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.services.thunar = {
    enable = lib.mkEnableOption "thunar";
  };

  config = lib.mkIf config.features.services.thunar.enable {
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}

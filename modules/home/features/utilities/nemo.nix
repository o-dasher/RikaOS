{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.utilities.nemo;
in
{
  options.features.utilities.nemo.enable =
    lib.mkEnableOption "Nemo file manager with archive, video thumbnailing, and default directory associations";

  config = lib.mkIf (config.features.utilities.enable && cfg.enable) {
    home.packages = with pkgs; [
      nemo-with-extensions
      nemo-fileroller # Archive integration
      ffmpegthumbnailer # Video thumbnails
    ];

    # Set nemo as default file manager
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "nemo.desktop";
    };
  };
}

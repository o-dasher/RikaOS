{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.utilities.nemo = {
    enable = lib.mkEnableOption "nemo";
  };

  config = lib.mkIf config.features.utilities.nemo.enable {
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

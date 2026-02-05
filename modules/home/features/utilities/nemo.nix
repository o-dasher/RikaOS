{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.utilities;
  cfg = modCfg.nemo;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
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

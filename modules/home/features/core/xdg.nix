{
  lib,
  config,
  ...
}:
let
  cfg = config.features.core.xdg;
in
{
  options.features.core.xdg = {
    enable = lib.mkEnableOption "XDG user directories, autostart entries, and MIME associations";
    portal.enable = lib.mkEnableOption "XDG desktop portal integration with xdg-open portal redirection";
  };

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    xdg = {
      enable = true;
      autostart = {
        enable = true;
        readOnly = true;
      };
      mime.enable = true;
      portal = lib.mkIf cfg.portal.enable {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}

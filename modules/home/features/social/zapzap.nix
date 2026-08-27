{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.zapzap;
in
{
  options.features.social.zapzap.enable = lib.mkEnableOption "WhatsApp via whatsapp-electron";

  config = lib.mkIf (config.features.social.enable && cfg.enable) {
    home.packages = [ pkgs.whatsapp-electron ];
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = pkgs.whatsapp-electron; })
    ];
  };
}

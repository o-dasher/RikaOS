{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.signal;
in
{
  options.features.social.signal.enable = lib.mkEnableOption "Signal.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.signal-desktop ];
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = pkgs.signal-desktop; })
    ];
  };
}

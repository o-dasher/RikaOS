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
  options.features.social.signal = {
    enable = lib.mkEnableOption "Signal.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.signal-desktop;
      description = "The Signal Desktop package to use.";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = cfg.package; })
    ];
  };
}

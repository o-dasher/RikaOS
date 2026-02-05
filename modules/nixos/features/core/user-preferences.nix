{ lib, config, ... }:
let
  modCfg = config.features.core;
  cfg = modCfg.userPreferences;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    time.timeZone = "Brazil/West";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "br-abnt2";
  };
}

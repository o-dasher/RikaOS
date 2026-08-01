{ lib, config, ... }:
let
  cfg = config.features.core.userPreferences;
in
{
  options.features.core.userPreferences.enable = lib.mkEnableOption "userPreferences";

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    time.timeZone = "America/Porto_Velho";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "br-abnt2";
  };
}

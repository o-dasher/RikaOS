{ lib, config, ... }:
{
  options.features.core.userPreferences = with lib; {
    enable = mkEnableOption "userPreferences";
  };

  config = lib.mkIf config.features.core.userPreferences.enable {
    time.timeZone = "Brazil/West";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "br-abnt2";
  };
}

{ lib, config, ... }:
{
  options.userPreferences = with lib; {
    enable = mkEnableOption "userPreferences";
  };

  config = lib.mkIf (config.userPreferences.enable) {
    time.timeZone = "Brazil/West";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "br-abnt2";
  };
}

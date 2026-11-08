{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.core.userPreferences;
in
{
  options.features.core.userPreferences.enable = lib.mkEnableOption "System-wide user preferences.";

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    time.timeZone = "America/Porto_Velho";
    console.keyMap = "br-abnt2";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-gtk
          kdePackages.fcitx5-qt
        ];
      };
    };
  };
}

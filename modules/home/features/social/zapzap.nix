{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.zapzap;
  pkg = pkgs.writeShellScriptBin "zapzap" ''
    exec ${lib.getExe pkgs.brave-origin} \
      --app=https://web.whatsapp.com \
      --user-data-dir="''${XDG_DATA_HOME:-$HOME/.local/share}/zapzap" \
      "$@"
  '';
in
{
  options.features.social.zapzap.enable = lib.mkEnableOption "WhatsApp PWA via Brave";

  config = lib.mkIf (config.features.social.enable && cfg.enable) {
    home.packages = [
      pkg
      (pkgs.makeDesktopItem {
        name = "zapzap";
        desktopName = "WhatsApp";
        exec = "${lib.getExe pkg} %U";
        icon = "whatsapp";
      })
    ];
    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { inherit pkg; }) ];
  };
}

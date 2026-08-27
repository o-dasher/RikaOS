{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.zapzap;
  pkg = pkgs.writeShellScriptBin "zapzap" ''
    exec ${lib.getExe pkgs.brave-origin} --app=https://web.whatsapp.com "$@"
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
  };
}

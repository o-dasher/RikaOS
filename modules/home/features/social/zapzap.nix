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
  options.features.social.zapzap = {
    enable = lib.mkEnableOption "WhatsApp web progressive web app wrapper via Brave";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "zapzap";
        pname = "zapzap";
        meta.mainProgram = "zapzap";
        paths = [
          (pkgs.writeShellScriptBin "zapzap" ''
            exec ${lib.getExe pkgs.brave-origin} --app=https://web.whatsapp.com "$@"
          '')
          (pkgs.makeDesktopItem {
            name = "zapzap";
            desktopName = "WhatsApp";
            exec = "zapzap %U";
            icon = "whatsapp";
            categories = [
              "Network"
              "InstantMessaging"
              "Chat"
            ];
            terminal = false;
            type = "Application";
          })
        ];
      };
      description = "The WhatsApp package to use.";
    };
  };

  config = lib.mkIf (config.features.social.enable && cfg.enable) {
    home.packages = [ cfg.package ];
  };
}

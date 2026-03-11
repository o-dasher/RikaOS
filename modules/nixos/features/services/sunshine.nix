{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.sunshine;

  screenToggle = pkgs.writeShellScriptBin "screen-toggle" ''
    case "$1" in
      off)
        hyprctl output create headless
        hyprctl keyword monitor HDMI-A-1,disable
        systemctl --user restart waybar
        ;;
      on)
        hyprctl keyword monitor HDMI-A-1,highres@highrr,0x0,1
        hyprctl output remove HEADLESS-1
        systemctl --user restart waybar
        ;;
    esac
  '';
in
with lib;
{
  options.features.services.sunshine = {
    enable = mkEnableOption "Sunshine game streaming server (for Moonlight clients)";
    screenToggle.enable = mkEnableOption "Turn off the physical display during remote sessions" // {
      default = true;
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = false;
        settings.sunshine_name = config.networking.hostName;
      };
    }
    (mkIf cfg.screenToggle.enable {
      services.sunshine.settings.global_prep_cmd = builtins.toJSON [
        {
          do = "${getExe screenToggle} off";
          undo = "${getExe screenToggle} on";
          elevated = "false";
        }
      ];
    })
  ]);
}

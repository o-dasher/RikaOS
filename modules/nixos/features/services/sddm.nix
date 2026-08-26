{
  pkgs,
  lib,
  config,
  themeLib,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.sddm;
in
{
  imports = [ ../../../lib ];
  options.features.services.sddm.enable = lib.mkEnableOption "SDDM Display Manager";

  config =
    let
      sddm-astronaut-override = pkgs.sddm-astronaut.override {
        embeddedTheme = "astronaut";
        themeConfig = {
          Background = config.stylix.image;
          CursorTheme = themeLib.cursor.name;
        };
      };

      inherit (config.rika.utils) idleTimers;

      sddmHypridleConfig = pkgs.writeText "sddm-hypridle.conf" ''
        general {
          after_sleep_cmd = ${lib.getExe' pkgs.hyprland "hyprctl"} 'dispatch(dpms, on)'
          inhibit_sleep = 3
        }

        listener {
          timeout = ${toString idleTimers.dpms}
          on-timeout = ${lib.getExe' pkgs.hyprland "hyprctl"} 'dispatch(dpms, off)'
          on-resume = ${lib.getExe' pkgs.hyprland "hyprctl"} 'dispatch(dpms, on)'
        }

        listener {
          timeout = ${toString idleTimers.suspend}
          on-timeout = ${lib.getExe' pkgs.systemd "systemctl"} suspend-then-hibernate
        }
      '';

      sddmHyprlandConfig = pkgs.writeText "sddm-hyprland.lua" ''
        package.path = "${../../../../dotfiles/hypr}/?.lua;" .. package.path
        require("sddm")
        hl.on("hyprland.start", function()
          hl.exec_cmd("${lib.getExe pkgs.hypridle} -c ${sddmHypridleConfig}")
        end)
      '';
    in
    lib.mkIf (modCfg.enable && cfg.enable) {
      # WORKAROUND: Fix non-functioning TTY switching under Hyprland.
      # Hyprland forwards VT switch requests to systemd-logind via DBus
      # (org.freedesktop.login1.chvt). Logind denies these requests by default
      # for SDDM's greeter session and unprivileged users, causing Ctrl+Alt+Fx
      # shortcuts to fail. This rule permits VT switching for SDDM and regular users (UID >= 1000).
      security.polkit.extraConfig = # js
        ''
          polkit.addRule(function(action, subject) {
            if ((action.id == "org.freedesktop.login1.chvt" || action.id == "org.freedesktop.login1.chvt-own-session") &&
                (subject.user == "sddm" || subject.uid >= 1000)) {
              return polkit.Result.YES;
            }
          });
        '';

      services.displayManager.sddm = {
        enable = true;
        extraPackages = [
          sddm-astronaut-override
          pkgs.kdePackages.qtmultimedia
          themeLib.cursor.package
        ];
        theme = "sddm-astronaut-theme";
        settings.Theme = {
          CursorTheme = themeLib.cursor.name;
          CursorSize = toString themeLib.cursor.size;
        };
        wayland = {
          enable = true;
          compositorCommand =
            #bash
            "start-hyprland -- --config ${sddmHyprlandConfig}";
        };
      };
    };
}

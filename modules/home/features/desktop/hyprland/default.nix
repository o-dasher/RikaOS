{
  pkgs,
  lib,
  config,
  options,
  osConfig ? null,
  ...
}:
let
  hasStylix = options ? stylix;
  hasUWSM = osConfig != null && osConfig.programs.hyprland.withUWSM;
  onGraphicalStart =
    pkg:
    {
      delay ? 0,
    }:
    let
      desktop = "${pkg}/share/applications/${pkg.meta.mainProgram or (lib.getName pkg)}.desktop";
      sleepCmd = lib.optionalString (delay > 0) "sleep ${toString delay};";
    in
    ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("sh -c 'while ! systemctl --user is-active --quiet graphical-session.target; do sleep 0.1; done; ${sleepCmd} app2unit ${desktop}'")
      end)
    '';
in
{
  options.features.desktop.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf (config.features.desktop.enable && config.features.desktop.hyprland.enable) {
    features.desktop.wayland.enable = true;
    programs.hyprlock.enable = true;
    home = {
      packages = with pkgs; [
        app2unit
        grimblast
        hyprshutdown
        xdg-terminal-exec
      ];

      file = config.rika.utils.xdgConfigSelectiveSymLink "hypr" [
        "config.lua"
        "monitors.lua"
        "rules.lua"
        "binds.lua"
      ] { };

      pointerCursor = {
        enable = true;
        hyprcursor.enable = lib.mkIf (hasStylix && config.features.desktop.theme.enable) true;
      };
    };
    services = {
      caffeine.enable = true;
      hyprpolkitagent.enable = true;
      playerctld.enable = true;
      hypridle =
        let
          exec = cmd: "${lib.getExe pkgs.app2unit} -s s -- ${cmd}";
          exec-sh = cmd: exec "sh -c '${cmd}'";
          inherit (config.rika.utils) idleTimers;
        in
        {
          enable = true;
          settings = {
            general = {
              lock_cmd = exec-sh "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${lib.getExe pkgs.hyprlock}";
              before_sleep_cmd = exec "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
              after_sleep_cmd = exec "${lib.getExe' pkgs.hyprland "hyprctl"} eval \"hl.dispatch(hl.dsp.dpms('on'))\"";
              inhibit_sleep = 3;
            };
            listener = [
              {
                timeout = idleTimers.lock;
                on-timeout = exec "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
              }
              {
                timeout = idleTimers.dpms;
                on-timeout = exec "${lib.getExe' pkgs.hyprland "hyprctl"} eval \"hl.dispatch(hl.dsp.dpms('off'))\"";
                on-resume = exec "${lib.getExe' pkgs.hyprland "hyprctl"} eval \"hl.dispatch(hl.dsp.dpms('on'))\"";
              }
              {
                timeout = idleTimers.suspend;
                on-timeout = exec "${lib.getExe' pkgs.systemd "systemctl"} suspend-then-hibernate";
              }
            ];
          };
        };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraLuaFiles.init = ./../../../../../dotfiles/hypr/init.lua;
      systemd = {
        enable = !hasUWSM;
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };

      extraConfig = lib.concatStringsSep "\n" (
        lib.optionals config.features.desktop.wayland.walker.enable [
          #lua
          ''hl.bind("SUPER + D", hl.dsp.exec_cmd("app2unit walker --nohints"))''
        ]
        ++ lib.optionals config.profiles.browser.enable [
          #lua
          ''
            hl.window_rule({ match = { class = "^(brave-origin)$" }, workspace = "2 silent" })
            ${onGraphicalStart config.programs.brave.finalPackage { delay = 1; }}
          ''
        ]
        ++ lib.optionals config.features.social.zapzap.enable [
          #lua
          ''
            hl.window_rule({ match = { class = "^(brave-web.whatsapp.com__-Default)$" }, workspace = "10 silent" })
            ${onGraphicalStart config.features.social.zapzap.package { delay = 3; }}
          ''
        ]
        ++ lib.optionals config.programs.nixcord.discord.vencord.enable [
          #lua
          ''hl.window_rule({ match = { class = "^(discord)$" }, workspace = "3 silent" })''
        ]
        ++ lib.optionals (hasStylix && config.features.desktop.theme.enable) [
          #lua
          ''
            hl.config({
              group = {
                groupbar = {
                  ["col.inactive"] = "${config.lib.stylix.mkOpacityHexColor config.lib.stylix.colors.base03 config.stylix.opacity.desktop}",
                },
              },
            })
          ''
        ]
      );
    };
  };
}

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
in
with lib;
{
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf (config.features.desktop.enable && config.features.desktop.hyprland.enable) {
    features.desktop.wayland.enable = true;
    programs.hyprlock.enable = true;
    home = {
      packages =
        with pkgs;
        [
          app2unit
          grimblast
          playerctl
          wireplumber
          xdg-terminal-exec
        ]
        ++ optionals (!hasUWSM) [ hyprshutdown ];

      file = config.rika.utils.xdgConfigSelectiveSymLink "hypr" [
        "config.lua"
        "monitors.lua"
        "rules.lua"
        "binds.lua"
      ] { };

      pointerCursor = {
        enable = true;
        hyprcursor.enable = mkIf (hasStylix && config.features.desktop.theme.enable) true;
      };
    };
    services = {
      hyprpolkitagent.enable = true;
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${getExe pkgs.hyprlock}";
            before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
            after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            inhibit_sleep = 3;
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
            }
            {
              timeout = 600;
              on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
              on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }
            {
              timeout = 1800;
              on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
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

      extraConfig = concatStringsSep "\n" (
        optionals config.features.desktop.wayland.walker.enable [
          #lua
          ''hl.bind("SUPER + D", hl.dsp.exec_cmd("app2unit walker --nohints"))''
        ]
        ++ [
          #lua
          ''hl.bind("CTRL + SHIFT + Q", hl.dsp.exec_cmd("app2unit ${
            if hasUWSM then "uwsm stop" else "hyprshutdown"
          }"))''
        ]
        ++ optionals config.profiles.browser.enable [
          #lua
          ''hl.workspace_rule({ workspace = 2, on_created_empty = "app2unit ${getExe config.programs.chromium.package}" })''
        ]
        ++ optionals config.programs.nixcord.discord.vencord.enable [
          #lua
          ''hl.window_rule({ match = { class = "^(discord)$" }, workspace = "3 silent" })''
        ]
        ++ optionals (hasStylix && config.features.desktop.theme.enable) [
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

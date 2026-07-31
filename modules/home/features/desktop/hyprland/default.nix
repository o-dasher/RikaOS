{
  pkgs,
  lib,
  config,
  options,
  osConfig ? null,
  inputs,
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
      packages = with pkgs; [
        app2unit
        grimblast
        hyprshutdown
        playerctl
        wireplumber
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
        hyprcursor.enable = mkIf (hasStylix && config.features.desktop.theme.enable) true;
      };

      # Prevent hyprland from picking the wrong gpu as the primary, which can hurt performance badly on reboots.
      sessionVariables.AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
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

    systemd.user.targets.hyprland-session =
      lib.mkIf config.wayland.windowManager.hyprland.systemd.enable
        {
          Unit.PropagatesStopTo = [ "graphical-session.target" ];
        };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        (pkgs.hyprlandPlugins.mkHyprlandPlugin {
          pluginName = "hyprselect";
          version = "unstable";
          src = inputs.hyprselect;
          installPhase = ''
            runHook preInstall
            mkdir -p $out/lib
            cp hyprselect.so $out/lib/hyprselect.so
            ln -s hyprselect.so $out/lib/libhyprselect.so
            runHook postInstall
          '';
          meta = {
            description = "A desktop selection box plugin for Hyprland";
            homepage = "https://github.com/jmanc3/hyprselect";
          };
        })
      ];
      extraLuaFiles.init = ./../../../../../dotfiles/hypr/init.lua;
      systemd = {
        enable = !hasUWSM;
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };

      extraConfig = concatStringsSep "\n" (
        optionals (!hasUWSM) [
          #lua
          ''
            hl.on("hyprland.shutdown", function()
              os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
            end)
          ''
        ]
        ++ optionals config.features.desktop.wayland.walker.enable [
          #lua
          ''hl.bind("SUPER + D", hl.dsp.exec_cmd("app2unit walker --nohints"))''
        ]
        ++ optionals config.profiles.browser.enable [
          #lua
          ''
            hl.window_rule({ match = { class = "^([hH]elium)$" }, workspace = "2 silent" })
            hl.on("hyprland.start", function()
              hl.exec_cmd("app2unit ${getExe config.programs.chromium.finalPackage}")
            end)
          ''
        ]
        ++ optionals config.programs.nixcord.discord.vencord.enable [
          #lua
          ''hl.window_rule({ match = { class = "^(discord)$" }, workspace = "3 silent" })''
        ]
        ++ optionals config.features.social.zapzap.enable [
          #lua
          ''hl.window_rule({ match = { class = "^(com\\.rtosta\\.zapzap)$" }, workspace = "10 silent" })''
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

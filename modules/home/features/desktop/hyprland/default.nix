{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.features.desktop.hyprland.enable = lib.mkEnableOption "hyprland";

  config =
    let
      gaps = 2;
      border_size = 2;
      rounding = 4;

      inherit (lib) getExe;
      hyprshutdown = inputs.hyprshutdown.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    lib.mkIf config.features.desktop.hyprland.enable {
      features.desktop.wayland.enable = true;
      programs.hyprlock.enable = true;
      services.hyprpolkitagent.enable = true;

      home.packages = [ hyprshutdown ];
      home.pointerCursor.hyprcursor.enable = true;

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
        systemd.enable = false; # UWSM managed.
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        settings = {
          env = [
            # Logging
            "AQ_TRACE,1"
            "HYPRLAND_TRACE,1"

            # Hyprland environment
            "XDG_CURRENT_DESKTOP,Hyprland"
          ];
          exec-once =
            with pkgs;
            [ "uwsm finalize" ]
            ++ lib.optionals config.programs.nixcord.vesktop.enable [
              "[workspace 3 silent] ${getExe app2unit} -- ${getExe vesktop} --start-minimized"
            ]
            ++ lib.optionals config.programs.nixcord.discord.enable [
              "[workspace 9 silent] ${getExe app2unit} -- ${getExe discord} --start-minimized"
            ]
            ++ lib.optionals config.profiles.browser.enable [
              "[workspace 2 silent] ${getExe app2unit} -- ${getExe config.profiles.browser.package}"
            ];
          workspace =
            with pkgs;
            lib.optionals config.programs.nixcord.vesktop.enable [
              "3, on-created-empty:${getExe app2unit} -- ${getExe vesktop}"
            ];
          debug = {
            disable_logs = false;
            full_cm_proto = 1; # Gamescope.
          };
          monitorv2 = [
            {
              output = "HDMI-A-1";
              mode = "highres@highrr";
              position = "0x0";
              bitdepth = 10;
              min_luminance = 0;
              max_luminance = 400;
            }
          ];
          # BUG: DS and tearing are mutually exclusive. It picks one depending on context.
          # e.g. Gamescope and majority of apps will tear. But native applications like
          # osu! will try to direct scanout unless specified to tear. This can be better in the future. See:
          # https://github.com/hyprwm/Hyprland/pull/10020 for reference.
          render.direct_scanout = true;
          layerrule = [
            "match:namespace ^(waybar|launcher)$, blur on"
          ];
          windowrule = [
            "tag +games, match:content game"
            "tag +games, match:class ^(steam_app_.*|gamescope|osu!)$"

            "tag +floaty, match:class ^(.blueman-manager-wrapped|thunar|com.github.wwmm.easyeffects|com.saivert.pwvucontrol)$"

            "match:tag games, sync_fullscreen on, no_shadow on, no_blur on, no_anim on, immediate on"
            "match:tag floaty, float on, center on, size (monitor_w*0.6) (monitor_h*0.6)"
          ];
          group.groupbar =
            let
              indicator_height = 24;
            in
            {
              inherit rounding;

              "col.inactive" = lib.mkForce (
                config.lib.stylix.mkOpacityHexColor config.lib.stylix.colors.base03 config.stylix.opacity.desktop
              );

              height = 1;
              font_size = 12;

              # Render text inside group bar indicator
              text_offset = -(indicator_height / 2);
              indicator_height = indicator_height;
            };
          general = {
            allow_tearing = true;
            inherit border_size;
            gaps_out = gaps;
            gaps_in = gaps;
          };
          decoration = {
            inherit rounding;
          };
          input = {
            kb_layout = "br";
            kb_variant = "abnt2";
            sensitivity = -2;
          };
          animations = {
            enabled = true;
            animation = map (name: "${name}, 1, 1, default") [
              "windows"
              "border"
              "layers"
              "borderangle"
              "fade"
              "workspaces"
            ];
          };
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          binde =
            with pkgs;
            with lib;
            let
              audioStep = toString 1;
            in
            [
              ", XF86AudioRaiseVolume, exec, ${getExe app2unit} -- ${wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ ${audioStep}%+"
              ", XF86AudioLowerVolume, exec, ${getExe app2unit} -- ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ ${audioStep}%-"
            ];
          bind =
            let
              mod = "SUPER";
            in
            with pkgs;
            lib.mkMerge [
              (lib.mkIf config.features.desktop.wayland.fuzzel.enable [
                "${mod}, D, exec, pkill -x fuzzel || ${getExe app2unit} -- ${getExe fuzzel}"
              ])
              [
                "${mod}, RETURN, exec, ${getExe app2unit} -- ${getExe xdg-terminal-exec}"

                "${mod}, F, fullscreen"
                "${mod}, C, killactive"
                "${mod}, M, fullscreen, on"

                "${mod}, S, togglegroup"
                "${mod} SHIFT, F, togglefloating"

                "${mod}, H, movefocus, l"
                "${mod}, L, movefocus, r"
                "${mod}, K, movefocus, u"
                "${mod}, J, movefocus, d"

                "${mod}, H, changegroupactive, b"
                "${mod}, L, changegroupactive, f"

                "${mod} SHIFT, H, movegroupwindow, b"
                "${mod} SHIFT, L, movegroupwindow, f"

                "${mod} SHIFT, H, moveintogroup, l"
                "${mod} SHIFT, L, moveintogroup, r"
                "${mod} SHIFT, K, moveintogroup, u"
                "${mod} SHIFT, J, moveintogroup, d"
                "${mod} SHIFT, U, moveoutofgroup"

                "${mod}, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy screen"
                "${mod} SHIFT, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy area"
                "${mod} ALT, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy active"

                "CTRL SHIFT, L, exec, ${getExe app2unit} -- ${getExe hyprlock}"
                "CTRL SHIFT, Q, exec, ${getExe hyprshutdown} -p 'uwsm stop'"

                ", XF86AudioPlay, exec, ${getExe app2unit} -- ${getExe playerctl} play-pause"
                ", XF86AudioPrev, exec, ${getExe app2unit} -- ${getExe playerctl} previous"
                ", XF86AudioNext, exec, ${getExe app2unit} -- ${getExe playerctl} next"
                ", XF86AudioStop, exec, ${getExe app2unit} -- ${getExe playerctl} stop"

                ", XF86AudioMicMute, exec, ${getExe app2unit} -- ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ", XF86AudioMute, exec, ${getExe app2unit} -- ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ]
              (builtins.concatLists (
                builtins.genList (
                  x:
                  let
                    workspace = x + 1;
                    key = toString (workspace - ((workspace / 10) * 10));
                  in
                  [
                    "${mod}, ${key}, workspace, ${toString workspace}"
                    "${mod} SHIFT, ${key}, movetoworkspace, ${toString workspace}"
                  ]
                ) 10
              ))
            ];
        };
      };
    };
}

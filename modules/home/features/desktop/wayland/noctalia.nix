{
  inputs,
  lib,
  pkgs,
  config,
  osConfig ? null,
  ...
}:
let
  cfg = config.features.desktop.wayland.noctalia;
  hasAmdgpu = osConfig != null && osConfig.features.hardware.amdgpu.enable;
  isLaptop = config.features.desktop.laptop.enable;
  inherit (config.rika.utils) idleTimers;
  mkCapsuleGroup =
    attrs:
    {
      enabled = true;
      accordion = false;
      accordion_direction = "end";
      border = "primary";
      fill = "surface";
      opacity = config.stylix.opacity.desktop;
      padding = 6.0;
    }
    // attrs;
  mkSysmon = stat: {
    inherit stat;
    type = "sysmon";
    visualization = "none";
    show_value = true;
    show_glyph = true;
    font_family = config.stylix.fonts.monospace.name;
  };
in
{
  imports = [
    "${inputs.home-manager}/modules/programs/noctalia"
  ];

  options.features.desktop.wayland.noctalia.enable = (lib.mkEnableOption "Noctalia shell.") // {
    default = true;
  };

  config = lib.mkIf (config.features.desktop.wayland.enable && cfg.enable) {
    home.packages = with pkgs; [
      brightnessctl
      cliphist
      ddcutil
      libnotify
      wlsunset
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      customPalettes.stylix.dark = with config.lib.stylix.colors.withHashtag; {
        mSecondary = lib.mkForce base0C;
        mSurfaceVariant = lib.mkForce base02;
        mHover = lib.mkForce base02;
        mOnHover = lib.mkForce base05;
      };

      settings = {
        dock.enabled = false;
        desktop_widgets.enabled = false;
        location.auto_locate = true;

        shell = {
          setup_wizard_enabled = false;
          polkit_agent = true;
          clipboard_enabled = true;
          disable_mipmaps = true;
          animation.enabled = false;
          time_format = "%H:%M:%S";
          date_format = "%A, %d/%m";
          shadow.alpha = 0.0;
          session = {
            power = {
              suspend = "systemctl suspend-then-hibernate";
              reboot = "systemctl reboot";
              shutdown = "systemctl poweroff";
            };
            actions = [
              {
                action = "lock";
              }
              {
                action = "logout";
                command = "umbriel msg session-quit skip-confirmation";
              }
              {
                action = "suspend";
              }
              {
                action = "reboot";
                command = "systemctl reboot";
              }
              {
                action = "shutdown";
                command = "systemctl poweroff";
              }
            ];
          };
          panel = {
            transparency_mode = "glass";
            control_center_placement = "floating";
            borders = true;
            shadow = false;
          };
          launcher = {
            categories = true;
            show_icons = true;
            sort_by_usage = true;
          };
          screenshot = {
            save_to_file = true;
            copy_to_clipboard = true;
            freeze_screen = true;
            filename_pattern = "screenshot_%Y%m%d_%H%M%S";
          };
        };

        bar.default = {
          position = "top";
          enabled = true;
          compositor_blur = true;
          thickness = 24;
          scale = 1.0;
          background_opacity = 0.0;
          margin_edge = 4;
          margin_ends = 4;
          padding = 0;
          widget_spacing = 2;
          shadow = false;
          capsule = true;
          capsule_thickness = 0.96;
          capsule_fill = "surface";
          capsule_border = "primary";
          capsule_opacity = config.stylix.opacity.desktop;

          monitor.fallback = {
            match = "FALLBACK";
            enabled = false;
          };

          start = [ "workspaces" ];
          center = [ "group:g4" ];
          end = [
            "group:g1"
            "group:g3"
            "group:g2"
            "control-center"
          ];

          capsule_group = [
            (mkCapsuleGroup {
              id = "g1";
              members = [
                "temp"
                "Separator"
                "cpu"
              ]
              ++ lib.optionals hasAmdgpu [
                "Separator"
                "gpu_usage"
                "Separator"
                "gpu_temp"
              ]
              ++ [
                "Separator"
                "ram"
              ]
              ++ lib.optionals isLaptop [
                "Separator"
                "battery"
              ];
            })
            (mkCapsuleGroup {
              id = "g2";
              widget_spacing = 8;
              members = [
                "input_volume"
                "Separator"
                "output_volume"
              ];
            })
            (mkCapsuleGroup {
              id = "g3";
              members = [
                "caffeine"
                "Separator"
                "network"
                "Separator"
                "bluetooth"
                "Separator"
                "tray"
              ];
            })
            (mkCapsuleGroup {
              id = "g4";
              members = [
                "clock"
                "notifications"
              ];
            })
          ];
        };

        widget = {
          network.show_label = false;
          bluetooth.show_label = false;
          notifications.hide_when_no_unread = false;

          Separator = {
            type = "text";
            text = "|";
          };

          workspaces = {
            hide_when_empty = true;
            show_labels = true;
            label_source = "id";
            style = "regular";
            focused_color = "primary";
            occupied_color = "surface_container";
            empty_color = "surface";
            urgent_color = "error";
            pill_scale = 1.0;
            active_pill_size = 2.0;
          };

          clock = {
            format = "%H:%M | %a %b %d |";
            tooltip_format = "%Y-%m-%d %H:%M:%S";
          };

          cpu = mkSysmon "cpu_usage";

          temp = mkSysmon "cpu_temp" // {
            capsule = true;
          };

          ram = mkSysmon "ram_used";

          output_volume = {
            type = "volume";
            device = "output";
            show_label = true;
          };

          input_volume = {
            type = "volume";
            device = "input";
            show_label = true;
          };

          tray = {
            drawer = false;
            hide_passive = false;
          };
        }
        // lib.optionalAttrs hasAmdgpu {
          gpu_usage = mkSysmon "gpu_usage";
          gpu_temp = mkSysmon "gpu_temp";
        }
        // lib.optionalAttrs isLaptop {
          battery = {
            display_mode = "glyph";
            show_label = true;
            label_content = "percent";
          };
        };

        notification = {
          enable_daemon = true;
          position = "top_right";
          border = true;
          max_visible = 5;
        };

        osd = {
          enabled = true;
          position = "top_right";
          border = true;
        };

        lockscreen = {
          enabled = true;
          lock_before_suspend = true;
          blurred_desktop = true;
          blur_intensity = 0.75;
          tint_intensity = 0.25;
          transition = [ "fade" ];
        };

        idle = {
          pre_action_fade_seconds = 5.0;
          behavior_order = [
            "lock"
            "screen-off"
            "suspend"
          ];
          behavior = {
            lock = {
              enabled = true;
              timeout = idleTimers.lock;
              action = "lock";
            };
            screen-off = {
              enabled = true;
              timeout = idleTimers.dpms;
              action = "screen_off";
            };
            suspend = {
              enabled = true;
              timeout = idleTimers.suspend;
              action = "command";
              command = "systemctl suspend-then-hibernate";
            };
          };
        };

        wallpaper = {
          enabled = true;
          fill_mode = "crop";
          transition_duration = 800.0;
          transition = [ "fade" ];
          monitor.fallback = {
            match = "FALLBACK";
            enabled = false;
          };
        };
      }
      // lib.optionalAttrs isLaptop {
        battery.warning_threshold = 25;
      };
    };

    systemd.user.services.noctalia = {
      Unit = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 5;
      };
      Service.RestartSec = "2s";
    };
  };
}

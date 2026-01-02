{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.features.desktop.wayland.waybar.enable = (lib.mkEnableOption "waybar") // {
    default = true;
  };

  config.programs.waybar =
    lib.mkIf (config.features.desktop.wayland.enable && config.features.desktop.wayland.waybar.enable)
      {
        enable = true;
        systemd.enable = true;
        settings.main =
          let
            define_temperature_sensor = name: i: j: {
              hwmon-path = "/sys/class/hwmon/hwmon${toString i}/temp${toString j}_input";
              critical-threshold = "80";
              format-critical = "  ${name} {temperatureC}°C";
              format = "${name} {temperatureC}°C";
            };
            hyprland = config.features.desktop.hyprland.enable;
          in
          lib.optionalAttrs hyprland {
            modules-left = [ "hyprland/workspaces" ];
            "hyprland/workspaces" = {
              all-outputs = true;
              on-click = "activate";
              persistent-workspaces = {
                "*" = 9;
              };
            };
          }
          // {
            modules-center = [ "clock" ];
            modules-right = [
              "temperature#cpu"
              "temperature#gpu"
              "cpu"
              "memory"
              "tray"
              "pulseaudio"
            ];

            layer = "top";
            position = "top";

            margin-bottom = 0;
            margin-top = 0;

            "temperature#cpu" = define_temperature_sensor "CPU" 1 1;
            "temperature#gpu" = define_temperature_sensor "GPU" 3 1;

            # Center
            clock = {
              format = "{:%H:%M | %a %b %d}";
            };

            # Right
            tray.spacing = 6;

            cpu = {
              format = "  {usage}%";
              tooltip = false;
            };

            memory = {
              interval = 30;
              format = " {used:0.2f}GB";
              max-length = 10;
              tooltip = false;
            };

            pulseaudio =
              let
                wheelstep = "1%";
                wpctl = "${pkgs.wireplumber}/bin/wpctl";
              in
              {
                on-click = "${lib.getExe pkgs.pwvucontrol}";
                on-scroll-up = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ ${wheelstep}+";
                on-scroll-down = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ ${wheelstep}-";
                format = "{icon}  {volume}% {format_source}";
                format-bluetooth = "{icon}  {volume}% {format_source}";
                format-bluetooth-muted = "  {format_source}";
                format-muted = "  {format_source}";
                format-source = " {volume}%";
                format-source-muted = "";
                format-icons = {
                  headphone = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
              };
          };
        style =
          let
            inherit (config.lib.stylix.colors) base00;
            border_definition = # css
              ''
                border-color: alpha(white, 0.25);
                border-style: solid;
              '';
          in
          lib.mkAfter (
            config.rika.utils.css.tailwindCSS # css
              ''
                @tailwind utilities;

                * {
                    @apply min-h-0;
                }

                window#waybar {
                    background: alpha(#${base00}, 0.5);
                }

                .modules-left {
                    @apply rounded-r-lg py-1 pl-1;
                }

                .modules-center {
                    @apply rounded-b-lg mb-1;
                }

                .modules-right {
                    @apply rounded-l-lg;
                }

                .modules-left, .modules-right {
                    @apply my-1 mx-0;
                }

                .modules-left, .modules-center, .modules-right {
                    @apply border;
                    ${border_definition}
                }

                #workspaces button {
                    @apply rounded-sm mr-1 p-0;
                }

                #tray,
                #cpu,
                #temperature,
                #memory,
                #backlight,
                #pulseaudio {
                    @apply py-0 px-2.5 border-r;
                    ${border_definition}
                }
              ''
          );
      };
}

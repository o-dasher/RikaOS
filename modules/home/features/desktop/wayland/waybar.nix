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

  config.stylix.targets.waybar.addCss = false;
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
              persistent-workspaces."*" = 10;
              format = "{icon}";
              format-icons = {
                default = "";
                active = "";
              };
            };
          }
          // {
            # SETUP
            layer = "top";
            position = "top";

            margin-bottom = 0;
            margin-top = 0;

            # CENTER
            modules-center = [ "clock" ];
            clock.format = "{:%H:%M | %a %b %d}";

            # RIGHT
            modules-right = [
              "temperature#cpu"
              "temperature#gpu"
              "cpu"
              "memory"
              "tray"
              "pulseaudio"
            ];
            "temperature#cpu" = define_temperature_sensor "CPU" 1 1;
            "temperature#gpu" = define_temperature_sensor "GPU" 3 1;
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
            tray.spacing = 6;
            pulseaudio =
              let
                wheelstep = "1%";
                wpctl = "${pkgs.wireplumber}/bin/wpctl";
              in
              {
                on-click = "${lib.getExe pkgs.pwvucontrol}";
                on-scroll-up = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ ${wheelstep}+";
                on-scroll-down = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ ${wheelstep}-";
                format = "{icon} {volume}% {format_source}";
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
            border_definition = # css
              ''
                border-color: @base0D;
                @apply border-solid;
              '';
          in
          lib.mkAfter (
            config.rika.utils.css.tailwindCSS # css
              ''
                @tailwind utilities;

                * {
                    @apply p-0 m-0 min-h-0;
                }

                window#waybar {
                    background: alpha(@base00, ${toString config.stylix.opacity.desktop});
                }

                .modules-center {
                    @apply rounded-b-lg mb-1 p-1 border-b border-x;
                    ${border_definition}
                }

                .modules-left, .modules-right {
                    @apply border rounded-lg my-1 mx-1 p-1;
                    ${border_definition}
                }

                .modules-left, .modules-right, .modules-center {
                    background: @base00;
                }

                #tray, #cpu, #temperature, #memory {
                    @apply border-r px-1;
                    ${border_definition}
                }

                #pulseaudio {
                    @apply px-1;
                }
              ''
          );
      };
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.rika.utils.css) tailwindCSS;
in
{
  options.features.desktop.hyprland.waybar.enable = (lib.mkEnableOption "waybar") // {
    default = true;
  };

  config.programs.waybar =
    lib.mkIf (config.features.desktop.hyprland.enable && config.features.desktop.hyprland.waybar.enable)
      {
        enable = true;
        systemd.enable = true;
        settings.main =
          let
            define_temperature_sensor = name: i: j: {
              hwmon-path = "/sys/class/hwmon/hwmon${toString i}/temp${toString j}_input";
              critical-threshold = "80";
              format-critical = "  ${name} {temperatureC}°C";
              format = "${name} {temperatureC}°C";
            };
          in
          {
            layer = "top";
            position = "top";
            margin-bottom = 0;
            margin-top = 0;

            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [
              "temperature#cpu"
              "temperature#gpu"
              "cpu"
              "memory"
              "tray"
              "pulseaudio"
              "battery"
            ];

            "temperature#cpu" = define_temperature_sensor "CPU" 1 1;
            "temperature#gpu" = define_temperature_sensor "GPU" 3 1;

            # Left
            "hyprland/workspaces" = {
              all-outputs = true;
              sort-by-name = true;
              on-click = "activate";
              persistent-workspaces = {
                "*" = 9;
              };
            };

            # Center
            clock = {
              format = "{:%H:%M | %a %b %d}";
            };

            # Right
            battery = {
              states = {
                warning = 20;
                critical = 15;
              };
              format = "{icon}  {capacity}%";
              format-charging = "  {capacity}%";
              format-plugged = "  {capacity}%";
              format-alt = "{icon}  {time}";
              format-icons = [
                " "
                " "
                " "
                ""
                ""
              ];
            };

            tray = {
              icon-size = 16;
              spacing = 6;
            };

            cpu = {
              format = "  {usage}%";
              tooltip = false;
              on-click = "${lib.getExe pkgs.ghostty} ${lib.getExe pkgs.htop}";
            };

            memory = {
              interval = 30;
              format = " {used:0.2f}GB";
              max-length = 10;
              tooltip = false;
              warning = 90;
              critical = 95;
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
                format-bluetooth = "{icon} {volume}% {format_source}";
                format-bluetooth-muted = " {format_source}";
                format-muted = "  {format_source}";
                format-source = " {volume}%";
                format-source-muted = "";
                format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "🎧";
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
            border_definition =
              # css
              ''
                @apply border-solid border-white/25;
              '';
          in
          lib.mkAfter (
            builtins.readFile (
              tailwindCSS pkgs config.lib.stylix.colors
                # css
                ''
                  @tailwind utilities;

                  * {
                      @apply min-h-0;
                  }

                  window#waybar {
                      @apply bg-base00/50;
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

                  #workspaces button.focused {
                      @apply py-0 px-1.5;
                  }

                  #tray,
                  #cpu,
                  #temperature,
                  #memory,
                  #backlight,
                  #pulseaudio,
                  #battery {
                      @apply py-0 px-2.5 border-r;
                      ${border_definition}
                  }
                ''
            )
          );
      };
}

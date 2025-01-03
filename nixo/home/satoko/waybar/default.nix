{
  lib,
  pkgs,
  utils,
  config,
  ...
}:
let
  inherit (utils) css;
  inherit (config.lib.stylix.colors) base00;
  inherit (css) font_definition alpha_fn;
in
{
  config = {
    programs.waybar = {
      enable = true;
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
          "temperature#gpu" = define_temperature_sensor "GPU" 1 1;

          # Left
          "hyprland/workspaces" = {
            all-outputs = true;
            sort-by-name = true;
            on-click = "activate";
            persistent-workspaces = {
              "*" = 6;
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
            on-click = "${lib.getExe pkgs.alacritty} htop";
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
              wheelstep = toString 0.1;
              pactl = "${pkgs.pulseaudio}/bin/pactl";
            in
            {
              on-click = "pavucontrol";
              on-scroll-up = "${pactl} -- set-sink-volume @DEFAULT_SINK@ +${wheelstep}dB";
              on-scroll-down = "${pactl} -- set-sink-volume @DEFAULT_SINK@ -${wheelstep}dB";
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
          border_definition = "1px solid ${alpha_fn "white" 0.1}";
        in
        ''
          * {
              ${font_definition}
              font-size: 12px;
              min-height: 0;
          }

          window#waybar {
              background: ${alpha_fn "#${base00}" 0.5};
          }

          .modules-left {
              border-radius: 0 4px 4px 0;
              padding: 4px 0 4px 4px;
          }

          .modules-center {
              border-radius: 0 0 4px 4px;
              margin-bottom: 4px;
          }

          .modules-right {
              border-radius: 4px 0 0 4px;
          }

          .modules-left, .modules-right {
              margin: 4px 0 4px 0;
          }

          .modules-left, .modules-center, .modules-right {
              border: ${border_definition};
          }

          #workspaces button {
              border-radius: 5%;
              margin-right: 4px;
              padding: 0;
          }

          #workspaces button.focused {
              padding: 0 6px;
          }

          #tray,
          #cpu, 
          #temperature, 
          #memory,
          #backlight, 
          #pulseaudio, 
          #battery {
              padding: 0 10px;
              border-right: ${border_definition};
          }
        '';
    };
  };
}

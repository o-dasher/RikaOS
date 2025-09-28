{
  lib,
  pkgs,
  utils,
  config,
  ...
}:
let
  inherit (utils) css;
  inherit (css) font_definition alpha_fn;
in
{
  options.desktop.hyprland.waybar.enable = (lib.mkEnableOption "waybar") // {
    default = true;
  };

  config.programs.waybar =
    lib.mkIf (config.desktop.hyprland.enable && config.desktop.hyprland.waybar.enable)
      {
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
              on-click = "${lib.getExe pkgs.ghostty} htop";
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
            inherit (config.lib.stylix.colors)
              base00
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;

            tailwindCSS =
              content:
              pkgs.runCommand "waybar-style.css"
                {
                  nativeBuildInputs = [ pkgs.nodePackages.tailwindcss ];
                  tailwindConfig =
                    pkgs.writeText "tailwind.config.js"
                      # js
                      ''
                        module.exports = {
                          content: ["./input.css"],
                          theme: {
                            extend: {
                              colors: {
                                base00: "#${base00}", base01: "#${base01}", base02: "#${base02}", base03: "#${base03}",
                                base04: "#${base04}", base05: "#${base05}", base06: "#${base06}", base07: "#${base07}",
                                base08: "#${base08}", base09: "#${base09}", base0A: "#${base0A}", base0B: "#${base0B}",
                                base0C: "#${base0C}", base0D: "#${base0D}", base0E: "#${base0E}", base0F: "#${base0F}"
                              }
                            }
                          },
                          plugins: [],
                        }
                      '';
                }
                ''
                  ln -s $tailwindConfig tailwind.config.js
                  cat > input.css <<EOF
                  ${content}
                  EOF
                  ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i input.css -o $out
                '';

            border_definition =
              # css
              ''
                border-color: ${alpha_fn "white" 0.25};
                @apply border-solid;
              '';
          in
          lib.mkAfter (
            builtins.readFile (tailwindCSS
            # css
            ''
              @tailwind utilities;

              * {
                  ${font_definition}
                  font-size: 12px;
                  @apply min-h-0;
              }

              window#waybar {
                  background: ${alpha_fn "#${base00}" 0.5};
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
                  @apply rounded-[5%] mr-1 p-0;
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
            '')
          );
      };
}

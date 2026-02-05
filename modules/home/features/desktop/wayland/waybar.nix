{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  modCfg = config.features.desktop.wayland;
  cfg = modCfg.waybar;
  hasStylix = options ? stylix;
in
with lib;
{
  config = mkIf (hasStylix && config.features.desktop.enable && modCfg.enable && cfg.enable) (
    optionalAttrs (options ? stylix) {
      stylix.targets.waybar.addCss = false;
    }
    // {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.main =
          let
            mkTempSensor = name: pciPath: {
              hwmon-path-abs = "/sys/bus/pci/devices/${pciPath}/hwmon";
              input-filename = "temp1_input";
              critical-threshold = 80;
              format-critical = "  ${name} {temperatureC}°C";
              format = "${name} {temperatureC}°C";
            };
          in
          optionalAttrs config.features.desktop.hyprland.enable {
            modules-left = [
              "hyprland/workspaces"
              "hyprland/workspaces#active"
            ];
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
            "hyprland/workspaces#active" = {
              active-only = true;
              format = "{name}";
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
            # Using hwmon-path-abs with stable PCI paths (won't change on reboot)
            # k10temp (AMD CPU) at 0000:00:18.3, amdgpu (GPU) at 0000:03:00.0
            "temperature#cpu" = mkTempSensor "CPU" "0000:00:18.3";
            "temperature#gpu" = mkTempSensor "GPU" "0000:03:00.0";
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
                on-click = getExe pkgs.pwvucontrol;
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
            border_definition = # css
              ''
                border-color: @base0D;
                @apply border-solid;
              '';
          in
          mkAfter (
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
                    @apply bg-[@base00];
                }

                #workspaces.active {
                    @apply mx-0.5;
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
  );
}

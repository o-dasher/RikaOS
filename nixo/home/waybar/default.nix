{ pkgs, ... }:
let
  inherit (import ../utils/default.nix) alpha_fn theme font_definition;
in
{
  programs.waybar = {
    enable = true;
    catppuccin.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      height = 35;
      margin-bottom = 0;
      margin-top = 0;

      modules-left = [ "sway/workspaces" ];
      modules-center = [
        "clock"
        "custom/notifications"
      ];
      modules-right = [
        "cpu"
        "memory"
        "tray"
        "pulseaudio"
        "battery"
      ];

      # Left
      "sway/workspaces" = {
        all-outputs = true;
        sort-by-name = true;
        on-click = "activate";
      };

      # Center
      clock = {
        format = "{:%H:%M | %a %b %d}";
      };

      "custom/notifications" = {
        format = "|  ";
        on-click = "swaync-client -t -sw";
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
        on-click = "xdg-terminal-exec htop";
      };

      memory = {
        interval = 30;
        format = " {used:0.2f}GB";
        max-length = 10;
        tooltip = false;
        warning = 90;
        critical = 95;
      };

      pulseaudio = {
        on-click = "pavucontrol";
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
        u = "4";

        border_definition = "1px solid ${alpha_fn "white" 0.1}";
        right_module_selectors = ''
          #tray,
          #cpu, 
          #temperature, 
          #memory,
          #backlight, 
          #pulseaudio, 
          #battery
        '';
      in
      ''
                *{
                	${font_definition}
                	font-size: 12px;
                	min-height: 0;
                }

                window#waybar {
        			background: ${alpha_fn theme.bg_color 0.5};
                }

                .modules-left {
                	border-radius: 0 ${u} ${u} 0;
                	padding: ${u} 0 ${u} ${u};
                }

                .modules-center {
                	border-radius: 0 0 ${u} ${u};
                	margin-bottom: ${u};
                }

                .modules-right {
                	border-radius: ${u} 0 0 ${u};
                }

                .modules-left, .modules-right {
                	margin: ${u} 0 ${u} 0;
                }

                .modules-left, .modules-center, .modules-right {
                	border: ${border_definition};
                }

                #workspaces button {
                	border-radius: 5%;
                	margin-right: ${u};
                	padding: 0;
                }

                #workspaces button.focused {
                	padding: 0 6;
                }

                ${right_module_selectors}, #clock {
                	padding: 0 10;
                }

                ${right_module_selectors} {
                	border-right: ${border_definition};
                }
      '';
  };
}

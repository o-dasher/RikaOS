{
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils) css;
  inherit (css) font_definition alpha_fn theme;
in
{
  config = {
    programs.waybar = {
      enable = true;
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
          on-click = "${lib.getExe pkgs.xdg-terminal-exec} htop";
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
              border-radius: 0 4 4 0;
              padding: 4 0 4 4;
          }

          .modules-center {
              border-radius: 0 0 4 4;
              margin-bottom: 4;
          }

          .modules-right {
              border-radius: 4 0 0 4;
          }

          .modules-left, .modules-right {
              margin: 4 0 4 0;
          }

          .modules-left, .modules-center, .modules-right {
              border: ${border_definition};
          }

          #workspaces button {
              border-radius: 5%;
              margin-right: 4;
              padding: 0;
          }

          #workspaces button.focused {
              padding: 0 6;
          }

          ${right_module_selectors} {
              padding: 0 10;
              border-right: ${border_definition};
          }
        '';
    };
  };
}

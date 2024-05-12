{
	programs.waybar = {
		enable = true;
		settings.main = {
			layer = "top";
			position = "top";
			height = 5;
			margin-bottom = 0;
			margin-top = 0;

			modules-left = ["cpu" "memory"];
			modules-center = ["sway/workspaces"];
			modules-right = ["tray" "pulseaudio" "backlight" "battery" "clock"];

			battery = {
				states = {
					warning = 20;
					critical = 15;
				};
				format = "{icon}&#8239; {capacity}%";
				format-charging = "&#8239; {capacity}%";
				format-plugged = "&#8239; {capacity}%";
				format-alt = "{icon} {time}";
				format-icons = [" " " " " " "" ""];
			};

			"wlr/workspaces" = {
				sort-by-name = true;
				on-click = "activate";
			};

			"sway/mode" = {
				format = "<span style=\"italic\">{}</span>";
			};

			tray = {
				icon-size = 16;
				spacing = 6;
			};

			clock = {
				locale = "C";
				format = " {:%I:%M %p}";
				format-alt = " {:%a,%b %d}";
			};

			cpu = {
				format = "&#8239; {usage}%";
				tooltip = false;
				on-click = "xdg-terminal -e 'htop'";
			};
			
			memory = {
				interval = 30;
				format = " {used:0.2f}GB";
				max-length = 10;
				tooltip = false;
				warning = 90;
				critical = 95;
			};

			backlight = {
				format = "{icon}&#8239;{percent}%";
				format-icons = ["" ""];
				on-scroll-down = "brightnessctl -c backlight set 1%-";
				on-scroll-up = "brightnessctl -c backlight set +1%";
			};
			
			pulseaudio = {
				on-click = "pavucontrol";
				format = "{icon} {volume}% {format_source}";
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
					default = ["" "" ""];
				};
			};

			"wlr/taskbar" = {
				format = "{icon} {title:.32}";
				icon-size = 14;
				icon-theme = "Numix-Circle";
				tooltip-format = "{title}";
				on-click = "activate";
				on-click-middle = "close";
			};
		};
		
		style = ''
		@import "." # todothis
		*{
			font-family: JetBrainsMono;
			font-size: 13px;
			min-height: 0;
			color: white;
		}

		window#waybar {
			background: alpha(@theme_base_color, 0.9)
		}

		#workspaces {
			margin-top: 3px;
			margin-bottom: 2px;
			margin-right: 10px;
			margin-left: 25px;
		}

		#workspaces button {
			border-radius: 0px;
			margin-right: 5px;
			padding: 1px 10px;
			font-weight: bolder;
		}

		.modules-left, .modules-center, .modules-right {
			background: shade(@theme_base_color, 1);
		}

		#workspaces button {
			background: shade(@theme_base_color, 1.5);
		}

		#workspaces button.active, #workspaces button.focused {
			padding: 0 10px;
			background: shade(@theme_base_color, 2.0);
		}

		#tray,
		#cpu, 
		#temperature, 
		#memory,
		#backlight, 
		#pulseaudio, 
		#disk,
		#battery, 
		#clock, 
		#network {
			padding: 0 10px;
		}
		'';
	};
}

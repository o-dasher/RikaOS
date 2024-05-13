let 
	inherit (import ../utils/default.nix) shade_fn alpha_fn theme font_definition;
in
{
	programs.waybar = {
		enable = true;
		settings.main = {
			layer = "top";
			position = "top";
			height = 35;
			margin-bottom = 0;
			margin-top = 0;

			modules-left = ["sway/workspaces"];
			modules-center = ["clock"];
			modules-right = ["cpu" "memory" "tray" "pulseaudio" "battery"];

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

			"sway/workspaces" = {
				all-outputs = true;
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
				format = "{:%H:%M | %a %b %d}";
			};

			cpu = {
				format = "&#8239; {usage}%";
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
		
		style = let 
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
		in ''
		*{
			${font_definition}
			font-size: 12px;
			min-height: 0;
			color: @theme_text_color;
		}

		window#waybar {
			background: ${alpha_fn theme.bg_color 0.9}
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
			background: ${shade_fn theme.base_color 1.4};
			border: ${border_definition};
		}

		#workspaces button {
			background: ${shade_fn theme.base_color 2};
			border-radius: 5%;
			margin-right: ${u};
			padding: 0;
		}

		#workspaces button.focused {
			background: ${alpha_fn theme.selected_bg_color 0.5};
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

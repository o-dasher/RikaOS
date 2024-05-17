{config, lib, pkgs, ...}:
{
	wayland.windowManager.sway = {
		enable = true;
		package = pkgs.swayfx;
		checkConfig = false;
		wrapperFeatures.gtk = true;
		extraConfig = ''
			corner_radius 8

			shadows enable
			shadow_blur_radius 8
		'';
		config = {
			modifier = "Mod4";
			terminal = "xdg-terminal";
			startup = [
				{command = "swww init";}
			];
			bars = [
				{
					position = "top";
					command = "waybar";
				}
			];
			gaps = let 
				gap = 4;
			in {
				inner = gap;
				outer = gap;
				horizontal = gap;
				vertical = gap;
			};
			window = {
				border = 1;
				titlebar = false;
			};
			input = {
				"*" = {
					tap = "enabled";
					xkb_layout = "br";
					xkb_variant = "abnt2";
					xkb_model = "abnt2";
				};
			};
			workspaceOutputAssign = [
				{output = "eDP-1"; workspace = "10";}
			] ++ builtins.map (i: {
				output = "HDMI-A-1";
				workspace = toString i;
			}) (builtins.genList (x: x + 1) 9);
			keybindings = let
				mod = config.wayland.windowManager.sway.config.modifier;
				key = {
					shift = "Shift";
					myprint = "p";
				};
				combo = s: "${mod}+${
					if builtins.typeOf s  == "string" then
						s
					else 
						builtins.concatStringsSep "+" s
				}";

				step = toString 1;

				run = s: a: "exec ${s} ${a}";
				runs = {
					playerctl = run "playerctl";
					pamixer = run "pamixer";
					brightnessctl = run "brightnessctl set";
					grimblast = run "grimblast --notify copy";
				};
			in
			# Default sway nix options are sane enough.
			lib.mkOptionDefault {
				# Opens user prefered terminal based on xdg-terminal.
				${combo "Return"} = "exec xdg-terminal-exec";

				# Reloading configurations.	
				${combo [key.shift "b"]} = run "pkill" "waybar && waybar";
				${combo [key.shift "c"]} = "swaymsg reload";

				# Toggle second monitor for better performance when required.
				"${combo "m"}" = "output \"eDP-1\" toggle";
				"${combo "d"}" = run "wofi" "--show drun -I -m -i --style $HOME/.config/wofi/style.css";

				
				# Windows.
				"${combo "f"}" = "fullscreen";
				"${combo "c"}" = "kill";

				# Screenshots
				"${combo key.myprint}" = runs.grimblast "screen";
				"${combo [key.shift key.myprint]}" = runs.grimblast "area";
				"${combo ["Alt" key.myprint]}" = runs.grimblast "active";

				# Media controls and other fns.
				"XF86AudioPlay" = runs.playerctl "play-pause";
				"XF86AudioPrev" = runs.playerctl "previous";
				"XF86AudioNext" = runs.playerctl "next";
				"XF86AudioStop" = runs.playerctl "stop";

				"XF86AudioRaiseVolume" = runs.pamixer "--increase ${step}";
				"XF86AudioLowerVolume" = runs.pamixer "--decrease ${step}";
				"XF86AudioMute" = runs.pamixer "--toggle-mute";
				"XF86AudioMicMute" = runs.pamixer "--default-source --toggle-mute";

				"XF86MonBrightnessUp" = runs.brightnessctl "${step}%+";
				"XF86MonBrightnessDown" = runs.brightnessctl "${step}%-";
			};
		};
	};
}

{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
	package = (config.lib.nixGL.wrap pkgs.wezterm);
    extraConfig = ''
        local wezterm = require 'wezterm'
        local config = {}

        config.font = wezterm.font 'JetBrains Mono'
        config.default_prog = {'fish'}

		config.tab_bar_at_bottom = true
        config.hide_tab_bar_if_only_one_tab = true

        local act = wezterm.action
        config.leader = { key="b", mods="CTRL" }

		config.inactive_pane_hsb = {
		  saturation = 1,
		  brightness = 0.25,
		}

        config.keys = {
      	{ key = "a", mods = "LEADER|CTRL",  action=act.SendString("\x01")},
      	{ key = "-", mods = "LEADER",       action=act.SplitVertical{domain="CurrentPaneDomain"}},
      	{ key = "\\",mods = "LEADER",       action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
      	{ key = "s", mods = "LEADER",       action=act.SplitVertical{domain="CurrentPaneDomain"}},
      	{ key = "v", mods = "LEADER",       action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
      	{ key = "o", mods = "LEADER",       action="TogglePaneZoomState" },
      	{ key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
      	{ key = "c", mods = "LEADER",       action=act.SpawnTab("CurrentPaneDomain")},
      	{ key = "h", mods = "LEADER",       action=act.ActivatePaneDirection("Left")},
      	{ key = "j", mods = "LEADER",       action=act.ActivatePaneDirection("Down")},
      	{ key = "k", mods = "LEADER",       action=act.ActivatePaneDirection("Up")},
      	{ key = "l", mods = "LEADER",       action=act.ActivatePaneDirection("Right")},
      	{ key = "H", mods = "LEADER|SHIFT", action=act.AdjustPaneSize{"Left", 5}},
      	{ key = "J", mods = "LEADER|SHIFT", action=act.AdjustPaneSize{"Down", 5}},
      	{ key = "K", mods = "LEADER|SHIFT", action=act.AdjustPaneSize{"Up", 5}},
      	{ key = "L", mods = "LEADER|SHIFT", action=act.AdjustPaneSize{"Right", 5}},
      	{ key = "1", mods = "LEADER",       action=act.ActivateTab(0)},
      	{ key = "2", mods = "LEADER",       action=act.ActivateTab(1)},
      	{ key = "3", mods = "LEADER",       action=act.ActivateTab(2)},
      	{ key = "4", mods = "LEADER",       action=act.ActivateTab(3)},
      	{ key = "5", mods = "LEADER",       action=act.ActivateTab(4)},
      	{ key = "6", mods = "LEADER",       action=act.ActivateTab(5)},
      	{ key = "7", mods = "LEADER",       action=act.ActivateTab(6)},
      	{ key = "8", mods = "LEADER",       action=act.ActivateTab(7)},
      	{ key = "9", mods = "LEADER",       action=act.ActivateTab(8)},
      	{ key = "&", mods = "LEADER|SHIFT", action={CloseCurrentTab={confirm=true}}},
      	{ key = "d", mods = "LEADER",       action={CloseCurrentPane={confirm=true}}},
      	{ key = "x", mods = "LEADER",       action={CloseCurrentPane={confirm=true}}},
      	{ key = 'p', mods = 'LEADER',		action=act.ActivateTabRelative(-1) },
      	{ key = 'n', mods = 'LEADER',		action=act.ActivateTabRelative(1) }
        }

        return config
    '';
  };
}

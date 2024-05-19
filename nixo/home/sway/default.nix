{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    wrapperFeatures.gtk = true;
    extraConfig =
      let
        radius = toString 4;
      in
      ''
        corner_radius ${radius}
        shadow_blur_radius ${radius} 

        shadows enable
      '';
    config = {
      modifier = "Mod4";
      terminal = "xdg-terminal";
      startup = [ { command = "swww init"; } ];
      bars = [
        {
          position = "top";
          command = "waybar";
        }
      ];
      gaps =
        let
          gap = 4;
        in
        {
          inner = gap;
          outer = gap;
          horizontal = gap;
          vertical = gap;
        };
      window = {
        border = 2;
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
      workspaceOutputAssign =
        [
          {
            output = "eDP-1";
            workspace = "10";
          }
        ]
        ++ builtins.map (i: {
          output = "HDMI-A-1";
          workspace = toString i;
        }) (builtins.genList (x: x + 1) 9);
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          key = {
            shift = "Shift";
            alt = "Alt";
            myprint = "p";
          };
          combo = s: "${mod}+${if builtins.typeOf s == "string" then s else builtins.concatStringsSep "+" s}";

          step = toString 1;

          run = s: a: "exec ${s} ${a}";
          run_no_args = s: run s "";

          runs = {
            playerctl = run "playerctl";
            pamixer = run "pamixer";
            brightnessctl = run "brightnessctl set";
            grimblast = run "grimblast --notify copy";
            swaymsg = run "swaymsg";
            restart_program = p: run "pkill" "${p} && ${p}";
          };
          standalones = {
            swaync_show = "swaync-client -t -sw";
          };
        in
        # Default sway nix options are sane enough.
        lib.mkOptionDefault {
          # Opens user prefered terminal based on xdg-terminal.
          ${combo "Return"} = "exec xdg-terminal-exec";

          # Reloading configurations.	
          ${
            combo [
              key.shift
              "b"
            ]
          } = runs.restart_program "waybar";
          ${
            combo [
              key.shift
              "c"
            ]
          } = runs.swaymsg "reload";
          ${
            combo [
              key.shift
              "n"
            ]
          } = run_no_args standalones.swaync_show;
          ${
            combo [
              key.alt
              "n"
            ]
          } = runs.restart_program "swaync";

          # Toggle second monitor for better performance when required.
          "${combo "m"}" = "output \"eDP-1\" toggle";
          "${combo "d"}" = run "wofi" "--show drun -I -m -i --style $HOME/.config/wofi/style.css";

          # Windows.
          "${combo "f"}" = "fullscreen";
          "${combo "c"}" = "kill";

          # Screenshots
          "${combo key.myprint}" = runs.grimblast "screen";
          "${combo [
            key.shift
            key.myprint
          ]}" = runs.grimblast "area";
          "${combo [
            key.alt
            key.myprint
          ]}" = runs.grimblast "active";

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

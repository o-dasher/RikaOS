{
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils) prefixset;
in
{
  config = {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      checkConfig = false;
      wrapperFeatures.gtk = true;
      extraConfig = ''
        shadows enable
        layer_effects 'waybar' 'blur enable'
      '';
      config =
        let
          mod = "Mod4";
        in
        {
          modifier = mod;
          terminal = lib.getExe pkgs.wezterm;
          bars = [
            {
              position = "top";
              command = lib.getExe pkgs.waybar;
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
              key = {
                shift = "Shift";
                alt = "Alt";
                myprint = "p";
              };

              step = toString 5;
              combo = s: "${mod}+${if builtins.typeOf s == "string" then s else builtins.concatStringsSep "+" s}";

              run = s: "exec ${s}";
            in
            # Default sway nix options are sane enough.
            lib.mkOptionDefault (
              {
                # Opens terminal
                ${combo "Return"} = run (lib.getExe pkgs.wezterm);

                # Windows.
                ${combo "f"} = "fullscreen";
                ${combo "c"} = "kill";
              }
              // prefixset (p: run "pkill ${p} && ${p}") {
                ${
                  combo [
                    key.shift
                    "b"
                  ]
                } = lib.getExe pkgs.waybar;
                ${
                  combo [
                    key.alt
                    "n"
                  ]
                } = lib.getExe pkgs.swaynotificationcenter;
              }
              // prefixset "output" { "${combo "m"}" = "\"eDP-1\" toggle"; }
              // prefixset (run "swaymsg") {
                ${
                  combo [
                    key.shift
                    "c"
                  ]
                } = "reload";
              }
              // prefixset (run (lib.getExe pkgs.wofi)) {
                ${combo "d"} = "--show drun -I -m -i --style $HOME/.config/wofi/style.css";
              }
              // prefixset (run "${lib.getExe pkgs.grimblast} --notify copy") {
                ${combo key.myprint} = "screen";
                ${
                  combo [
                    key.shift
                    key.myprint
                  ]
                } = "area";
                ${
                  combo [
                    key.alt
                    key.myprint
                  ]
                } = "active";
              }
              # Media keys
              // prefixset (run "${lib.getExe pkgs.brightnessctl} set") {
                XF86MonBrightnessUp = "${step}%+";
                XF86MonBrightnessDown = "${step}%-";
              }
              // prefixset (run (lib.getExe pkgs.playerctl)) {
                XF86AudioPlay = "play-pause";
                XF86AudioPrev = "previous";
                XF86AudioNext = "next";
                XF86AudioStop = "stop";
              }
              // prefixset (run (lib.getExe pkgs.pamixer)) {
                XF86AudioMicMute = "--default-source --toggle-mute";
                XF86AudioRaiseVolume = "--increase ${step}";
                XF86AudioLowerVolume = "--decrease ${step}";
                XF86AudioMute = "--toggle-mute";
              }
            );
        };
    };
  };
}

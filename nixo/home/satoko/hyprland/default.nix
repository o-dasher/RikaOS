{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  config.wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = lib.getExe pkgs.waybar;
      monitor = [ "HDMI-A-1,1920x1080@239.76,0x0,1" ];
      general =
        let
          gap = 5;
        in
        {
          gaps_out = gap;
          gaps_in = gap;
        };
      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
        sensitivity = -0.6;
      };
      animations = {
        enabled = true;
        animation = builtins.map (name: "${name}, 1, 1, default") [
          "windows"
          "border"
          "layers"
          "borderangle"
          "fade"
          "workspaces"
        ];
      };
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      binde =
        let
          audioStep = toString 0.1;
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
        [
          ", XF86AudioRaiseVolume, exec, ${pactl} -- set-sink-volume @DEFAULT_SINK@ +${audioStep}dB"
          ", XF86AudioLowerVolume, exec, ${pactl} -- set-sink-volume @DEFAULT_SINK@ -${audioStep}dB"
        ];
      bind =
        let
          mod = "SUPER";
        in
        [
          "${mod}, RETURN, exec, ${getExe pkgs.alacritty}"

          "${mod}, F, fullscreen"
          "${mod}, C, killactive"

          "${mod}, S, togglegroup"
          "${mod} SHIFT, F, togglefloating"

          "${mod}, H, movefocus, l"
          "${mod}, L, movefocus, r"
          "${mod}, K, movefocus, u"
          "${mod}, J, movefocus, d"

          "${mod}, H, changegroupactive, b"
          "${mod}, L, changegroupactive, f"
          "${mod} SHIFT, H, movegroupwindow, b"
          "${mod} SHIFT, L, movegroupwindow, f"

          "${mod}, D, exec, pkill ${getExe pkgs.wofi} || ${getExe pkgs.wofi} --show drun -I -m -i --style $HOME/.config/wofi/style.css"

          "${mod}, P, exec, ${getExe pkgs.grimblast} --notify copy screen"
          "${mod} SHIFT, P, exec, ${getExe pkgs.grimblast} --notify copy area"
          "${mod} ALT, P, exec, ${getExe pkgs.grimblast} --notify copy active"

          ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
          ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"
          ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
          ", XF86AudioStop, exec, ${getExe pkgs.playerctl} stop"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            x:
            let
              workspace = x + 1;
              key = builtins.toString (workspace - ((workspace / 10) * 10));
            in
            [
              "${mod}, ${key}, workspace, ${toString workspace}"
              "${mod} SHIFT, ${key}, movetoworkspace, ${toString workspace}"
            ]
          ) 10
        ))
        ++ [
          ", XF86AudioMicMute, exec, ${getExe pkgs.pamixer} --default-source --toggle-mute"
          ", XF86AudioMute, exec, ${getExe pkgs.pamixer} --toggle-mute"
        ];
    };
  };
}

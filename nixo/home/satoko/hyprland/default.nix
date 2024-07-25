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
      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
      };
      bind =
        let
          mod = "SUPER";
          eachworkspace = fn: builtins.map (i: fn (toString i)) (builtins.genList (x: x + 1) 10);
        in
        [
          "${mod}, RETURN, exec, ${lib.getExe pkgs.wezterm}"

          "${mod}, F, fullscreen"
          "${mod}, C, killactive"
          "${mod}, F, togglefloating"

          "${mod}, H, movefocus, l"
          "${mod}, L, movefocus, r"
          "${mod}, K, movefocus, u"
          "${mod}, J, movefocus, d"

          "${mod}, D, exec, pkill ${getExe pkgs.wofi} || ${getExe pkgs.wofi} --show durn -I -m -i --style $HOME/.config/wofi/style.css"

          "${mod}, P, exec, ${getExe pkgs.grimblast} --notify copy screen"
          "${mod} SHIFT, P, exec, ${getExe pkgs.grimblast} --notify copy area"
          "${mod} ALT, P, exec, ${getExe pkgs.grimblast} --notify copy active"

          ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
          ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"
          ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
          ", XF86AudioStop, exec, ${getExe pkgs.playerctl} stop"
        ]
        ++ eachworkspace (i: "${mod}, ${i}, workspace, ${i}")
        ++ eachworkspace (i: "${mod} SHIFT, ${i}, movetoworkspace, ${i}")
        ++ (
          let
            audioStep = toString 5;
          in
          [
            ", XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} --increase ${audioStep}"
            ", XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} --decrease ${audioStep}"
            ", XF86AudioMicMute, exec, ${getExe pkgs.pamixer} --default-source --toggle-mute"
            ", XF86AudioMute, exec, ${getExe pkgs.pamixer} --toggle-mute"
          ]
        );
    };
  };
}

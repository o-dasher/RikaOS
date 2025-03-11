{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) getExe;
in
{
  imports = [
    ./mako.nix
    ./waybar.nix
    ./fuzzel.nix
  ];

  options.desktop.hyprland.enable = lib.mkEnableOption "hyprland";
  config = lib.mkIf config.desktop.hyprland.enable {
    programs.hyprlock.enable = true;
    home.pointerCursor.hyprcursor.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      settings = {
        env = [
          "HYPRCURSOR_SIZE, 24"
          "XCURSOR_SIZE, 24"

          # Wayland stuff.
          "NIXOS_WAYLAND,1" # Enable Wayland support in NixOS
          "NIXOS_OZONE_WL,1" # Enable Ozone Wayland support in NixOS
          "ELECTRON_OZONE_PLATFORM_HINT,auto" # Set Electron to automatically choose between Wayland and X11
        ];
        exec-once = [
          ((lib.mkIf (config.desktop.hyprland.waybar.enable)) (lib.getExe pkgs.waybar))
          (lib.getExe pkgs.lxqt.lxqt-policykit)
          "[workspace 9 silent] ${lib.getExe pkgs.qbittorrent}"
        ];
        debug.disable_logs = false;
        monitor = [ "HDMI-A-1,1920x1080@239.76,0x0,1" ];
        # render.direct_scanout = true; I get bugs here and then still on csgo, when idling for too long e.g.
        windowrulev2 = [
          "immediate, fullscreen:1"
          "float, class:org.gnome.Nautilus"
        ];
        misc = {
          render_ahead_of_time = true;
          render_ahead_safezone = 4;
        };
        general =
          {
            allow_tearing = true;
            border_size = 3;
          }
          // (
            let
              gap = 5;
            in
            {
              gaps_out = gap;
              gaps_in = gap;
            }
          );
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
            audioStep = toString 1;
          in
          [
            ", XF86AudioRaiseVolume, exec, ${getExe pkgs.pamixer} -i ${audioStep}"
            ", XF86AudioLowerVolume, exec, ${getExe pkgs.pamixer} -d ${audioStep}"
          ];
        bind =
          let
            mod = "SUPER";
          in
          lib.mkMerge [
            (lib.mkIf config.desktop.hyprland.fuzzel.enable [
              "${mod}, D, exec, pkill ${getExe pkgs.fuzzel} || ${getExe pkgs.fuzzel}"
            ])
            [
              "${mod}, RETURN, exec, ${getExe pkgs.xdg-terminal-exec}"

              "${mod}, F, fullscreen"
              "${mod}, C, killactive"
              "${mod}, M, fullscreen, 1"

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

              "${mod} SHIFT, H, moveintogroup, l"
              "${mod} SHIFT, L, moveintogroup, r"
              "${mod} SHIFT, K, moveintogroup, u"
              "${mod} SHIFT, J, moveintogroup, d"
              "${mod} SHIFT, U, moveoutofgroup"

              "${mod}, P, exec, ${getExe pkgs.grimblast} --notify copy screen"
              "${mod} SHIFT, P, exec, ${getExe pkgs.grimblast} --notify copy area"
              "${mod} ALT, P, exec, ${getExe pkgs.grimblast} --notify copy active"

              "CTRL ALT, L, exec, ${getExe pkgs.hyprlock}"

              ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
              ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"
              ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
              ", XF86AudioStop, exec, ${getExe pkgs.playerctl} stop"

              ", XF86AudioMicMute, exec, ${getExe pkgs.pamixer} --default-source --toggle-mute"
              ", XF86AudioMute, exec, ${getExe pkgs.pamixer} --toggle-mute"
            ]
            (builtins.concatLists (
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
          ];
      };
    };
  };
}

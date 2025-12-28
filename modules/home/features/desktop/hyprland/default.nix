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
    services.hyprpolkitagent.enable = true;

    home.pointerCursor = {
      name = "BreezeX-RosePine-Linux";
      hyprcursor.enable = true;
      package = pkgs.rose-pine-cursor;
    };

    gtk = {
      enable = true;
      cursorTheme = {
        name = config.home.pointerCursor.name;
        package = config.home.pointerCursor.package;
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      settings = {
        env = [
          # Logging
          "AQ_TRACE,1"
          "HYPRLAND_TRACE,1"

          "XDG_CURRENT_DESKTOP,Hyprland" # Set xdg desktop to hyprland
        ];
        exec-once =
          with pkgs;
          lib.optionals config.programs.nixcord.vesktop.enable [
            "[workspace 3 silent] ${getExe app2unit} -- ${getExe vesktop} --start-minimized"
          ]
          ++ lib.optionals config.programs.nixcord.discord.enable [
            "[workspace 9 silent] ${getExe app2unit} -- ${getExe discord} --start-minimized"
          ];
        workspace =
          with pkgs;
          lib.optionals config.programs.nixcord.vesktop.enable [
            "3, on-created-empty:${getExe app2unit} -- ${getExe vesktop}"
          ];
        debug = {
          disable_logs = false;
          full_cm_proto = 1; # Gamescope.
        };
        monitor = [ "HDMI-A-1,1920x1080@239.76,0x0,1" ];
        # BUG: DS and tearing are mutually exclusive. It picks one depending on context.
        # e.g. Gamescope and majority of apps will tear. But native applications like
        # osu! will try to direct scanout unless specified to tear. This can be better in the future. See:
        # https://github.com/hyprwm/Hyprland/pull/10020 for reference.
        render.direct_scanout = true;
        windowrule = [
          "tag +games, match:content game"
          "tag +games, match:class ^(steam_app_.*|gamescope|osu!)$"

          "sync_fullscreen on,match:tag games"
          "no_shadow on, match:tag games"
          "no_blur on, match:tag games"
          "no_anim on, match:tag games"
          "immediate on, match:tag games"

          "match:class org.gnome.Nautilus, float on"
        ];
        group.groupbar =
          let
            indicator_height = 24;
          in
          {
            height = 1;
            font_size = 12;

            # Render text inside group bar indicator
            text_offset = -(indicator_height / 2);
            indicator_height = indicator_height;
          };
        general = {
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
          sensitivity = -2;
        };
        animations = {
          enabled = true;
          animation = map (name: "${name}, 1, 1, default") [
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
          with pkgs;
          let
            audioStep = toString 1;
          in
          [
            ", XF86AudioRaiseVolume, exec, ${wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ ${audioStep}%"
            ", XF86AudioLowerVolume, exec, ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ ${audioStep}%-"
          ];
        bind =
          let
            mod = "SUPER";
          in
          with pkgs;
          lib.mkMerge [
            (lib.mkIf config.desktop.hyprland.fuzzel.enable [
              "${mod}, D, exec, pkill -x fuzzel || ${getExe app2unit} -- ${getExe fuzzel}"
            ])
            [
              "${mod}, RETURN, exec, ${getExe app2unit} -- ${getExe xdg-terminal-exec}"

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

              "${mod}, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy screen"
              "${mod} SHIFT, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy area"
              "${mod} ALT, P, exec, ${getExe app2unit} -- ${getExe grimblast} --notify copy active"

              "CTRL ALT, L, exec, ${getExe app2unit} -- ${getExe hyprlock}"

              ", XF86AudioPlay, exec, ${getExe playerctl} play-pause"
              ", XF86AudioPrev, exec, ${getExe playerctl} previous"
              ", XF86AudioNext, exec, ${getExe playerctl} next"
              ", XF86AudioStop, exec, ${getExe playerctl} stop"

              ", XF86AudioMicMute, exec, ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ", XF86AudioMute, exec, ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ]
            (builtins.concatLists (
              builtins.genList (
                x:
                let
                  workspace = x + 1;
                  key = toString (workspace - ((workspace / 10) * 10));
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

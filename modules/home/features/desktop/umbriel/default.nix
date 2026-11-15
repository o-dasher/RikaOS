{
  pkgs,
  lib,
  config,
  options,
  themeLib,
  ...
}:
let
  cfg = config.features.desktop.umbriel;
  hasStylix = options ? stylix;
  colors = config.lib.stylix.colors;
in
{
  options.features.desktop.umbriel.enable = lib.mkEnableOption "Umbriel compositor.";

  config = lib.mkIf cfg.enable {
    features.desktop.wayland.enable = true;

    home = {
      packages = with pkgs; [
        app2unit
        xdg-terminal-exec
      ];

      pointerCursor.enable = true;
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-umbriel
          xdg-desktop-portal-gtk
        ];
        config.umbriel.default = [
          "umbriel"
          "gtk"
        ];
      };

      configFile = {
        "umbriel/config.toml".source = ../../../../../dotfiles/umbriel/config.toml;

        "umbriel/theme.toml" = lib.mkIf (hasStylix && config.features.desktop.theme.enable) {
          text = ''
            [colors]
            background = "#${colors.base00}"
            accent_primary = "#${colors.base0D}"
            accent_secondary = "#${colors.base0E}"
            error = "#${colors.base08}"
            warning = "#${colors.base0A}"

            [colors.border]
            focused = "#${colors.base0D}"
            unfocused = "#${colors.base03}"

            [input.cursor]
            theme = "${themeLib.cursor.name}"
            size = ${toString themeLib.cursor.size}
          '';
        };

        "umbriel/rules.toml".text = lib.concatStringsSep "\n" (
          lib.optionals (config.profiles.browser.enable && config.profiles.browser.brave.enable) [
            ''
              [[window_rule]]
              match.app_id = "^(brave-origin)$"
              default_workspace = "2"
              default_focused = false
              default_maximize = true
            ''
          ]
          ++ lib.optionals config.features.social.signal.enable [
            ''
              [[window_rule]]
              match.app_id = "^(signal)$"
              default_workspace = "3"
              default_focused = false
              default_maximize = true
              default_scrolling_column_order = 1
            ''
          ]
          ++ lib.optionals config.programs.nixcord.discord.vencord.enable [
            ''
              [[window_rule]]
              match.app_id = "^(discord)$"
              match.title = "^(Discord Updater)$"
              default_floating = true

              [[window_rule]]
              match.app_id = "^(discord)$"
              default_workspace = "3"
              default_focused = false
              default_maximize = true
              default_scrolling_column_order = 2
            ''
          ]
          ++ lib.optionals config.features.social.zapfast.enable [
            ''
              [[window_rule]]
              match.app_id = "^(zapfast)$"
              default_workspace = "3"
              default_focused = false
              default_maximize = true
              default_scrolling_column_order = 3
            ''
          ]
          ++ lib.optionals config.features.desktop.laptop.enable [
            ''
              [output.eDP-1]
              position = [0, 0]
              workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

              [input.touchpad]
              natural_scroll = true
              tap = true

              [events]
              lid_close = "umbriel msg output-disable eDP-1"
              lid_open = "umbriel msg output-enable eDP-1"
            ''
          ]
        );
      };
    };
  };
}

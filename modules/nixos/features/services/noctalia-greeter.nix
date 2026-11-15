{
  lib,
  config,
  options,
  themeLib,
  ...
}:
let
  cfg = config.features.services.noctalia-greeter;
  hasStylix = options ? stylix;
  colors = config.lib.stylix.colors;
  inherit (config.rika.utils) idleTimers;
in
{
  options.features.services.noctalia-greeter.enable =
    lib.mkEnableOption "Noctalia Greetd display manager.";

  config = lib.mkIf cfg.enable {
    # WORKAROUND: Fix non-functioning TTY switching under Wayland compositors.
    # Compositors forward VT switch requests to systemd-logind via DBus
    # (org.freedesktop.login1.chvt). Logind denies these requests by default
    # for the greeter session and unprivileged users, causing Ctrl+Alt+Fx
    # shortcuts to fail. This rule permits VT switching for greeter and regular users (UID >= 1000).
    security.polkit.extraConfig = # js
      ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.login1.chvt" || action.id == "org.freedesktop.login1.chvt-own-session") &&
              (subject.user == "greeter" || subject.uid >= 1000)) {
            return polkit.Result.YES;
          }
        });
      '';

    services.displayManager.noctalia-greeter = {
      enable = true;

      cursorTheme = {
        inherit (themeLib.cursor) name package;
      };

      settings = {
        session.default = "umbriel";
        idle.timeout = idleTimers.dpms;
        cursor.size = themeLib.cursor.size;
        output.refresh_rate = 999;
        user.default = lib.findFirst (n: config.users.users.${n}.isNormalUser) null (
          builtins.attrNames config.users.users
        );
      }
      // lib.optionalAttrs hasStylix {
        appearance = {
          scheme = "Synced";
          theme_mode = config.stylix.polarity;
          font_family = config.stylix.fonts.sansSerif.name;

          wallpaper = {
            path = "${config.stylix.image}";
            fill_mode = "crop";
          };

          palette = {
            primary = "#${colors.base0D}";
            on_primary = "#${colors.base00}";
            secondary = "#${colors.base0E}";
            on_secondary = "#${colors.base00}";
            tertiary = "#${colors.base0C}";
            on_tertiary = "#${colors.base00}";
            error = "#${colors.base08}";
            on_error = "#${colors.base00}";
            surface = "#${colors.base00}";
            on_surface = "#${colors.base05}";
            surface_variant = "#${colors.base01}";
            on_surface_variant = "#${colors.base04}";
            outline = "#${colors.base03}";
            shadow = "#${colors.base00}";
            hover = "#${colors.base02}";
            on_hover = "#${colors.base05}";
          };
        };
      };
    };
  };
}

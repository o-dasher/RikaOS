{
  pkgs,
  lib,
  config,
  options,
  osConfig ? null,
  ...
}:
let
  cfg = config.features.desktop.hyprland;
  hasStylix = options ? stylix;
  hasUWSM = osConfig != null && osConfig.programs.hyprland.withUWSM;
in
{
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland.";
    laptop.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.features.desktop.laptop.enable;
      defaultText = lib.literalExpression "config.features.desktop.laptop.enable";
      description = "Laptop-specific Hyprland configuration.";
    };
  };

  config = lib.mkIf (config.features.desktop.enable && cfg.enable) {
    features.desktop.wayland.enable = true;

    home = {
      packages = with pkgs; [
        app2unit
        xdg-terminal-exec
      ];

      file = config.rika.utils.xdgConfigSelectiveSymLink "hypr" [
        "init.lua"
        "commons.lua"
        "config.lua"
        "monitors.lua"
        "rules.lua"
        "binds.lua"
        "utils.lua"
      ] { };

      pointerCursor = {
        enable = true;
        hyprcursor.enable = lib.mkIf (hasStylix && config.features.desktop.theme.enable) true;
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd = {
        enable = !hasUWSM;
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };

      extraConfig = lib.concatStringsSep "\n" (
        [
          #lua
          ''require("init")''
        ]
        ++ lib.optionals (config.profiles.browser.enable && config.profiles.browser.brave.enable) [
          #lua
          ''hl.window_rule({ match = { class = "^(brave-origin)$" }, workspace = "2 silent" })''
        ]
        ++ lib.optionals config.programs.nixcord.discord.vencord.enable [
          #lua
          ''
            hl.window_rule({ match = { class = "^(discord)$", title = "^(Discord Updater)$" }, float = true })
            hl.window_rule({ match = { class = "^(discord)$", initial_title = "^(Discord)$" }, workspace = "3 silent", maximize = true })
            hl.window_rule({ match = { class = "^(discord)$" }, workspace = "3 silent" })
          ''
        ]
        ++ lib.optionals config.features.social.signal.enable [
          #lua
          ''hl.window_rule({ match = { class = "^(signal)$" }, workspace = "3 silent", maximize = true })''
        ]
        ++
          lib.optionals
            (config.programs.nixcord.discord.vencord.enable && config.features.social.signal.enable)
            [
              #lua
              ''
                require("utils").organize_side_by_side({
                  workspace = 3,
                  left = { class = "discord", exclude = "Updater" },
                  right = "signal",
                  maximize = true,
                })
              ''
            ]
        ++ lib.optionals (hasStylix && config.features.desktop.theme.enable) [
          #lua
          ''
            hl.config({
              group = {
                groupbar = {
                  ["col.inactive"] = "${config.lib.stylix.mkOpacityHexColor config.lib.stylix.colors.base03 config.stylix.opacity.desktop}",
                },
              },
            })
          ''
        ]
        ++ lib.optionals cfg.laptop.enable [
          #lua
          ''
            -- Laptop brightness keys
            hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up 5"), { locked = true, repeating = true })
            hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down 5"), { locked = true, repeating = true })
            hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("noctalia msg keyboard-backlight-up"), { locked = true, repeating = true })
            hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("noctalia msg keyboard-backlight-down"), { locked = true, repeating = true })

            hl.config({
              input = {
                touchpad = {
                  natural_scroll = true,
                  ["tap-to-click"] = true,
                },
              },
              gestures = {
                workspace_swipe = true,
              },
            })

            hl.gesture({
              fingers = 3,
              direction = "horizontal",
              action = "workspace",
            })
          ''
        ]
      );
    };
  };
}

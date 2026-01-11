{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  hasStylix = options ? stylix;
in
{
  options.features.desktop.wayland.walker.enable = (lib.mkEnableOption "walker") // {
    default = true;
  };

  config =
    lib.mkIf (config.features.desktop.wayland.enable && config.features.desktop.wayland.walker.enable)
      {
        programs.walker = {
          enable = true;
          runAsService = true;
          config = {
            theme = "stylix";
            list.max_entries = 10;
            terminal = lib.getExe pkgs.xdg-terminal-exec;
          };
          themes.stylix.style = lib.optionalString hasStylix (
            let
              inherit (config.lib.stylix) colors mkOpacityHexColor;
              opacity = config.stylix.opacity.popups;
            in
            # css
            ''
              @define-color window_bg_color ${mkOpacityHexColor colors.base00 opacity};
              @define-color accent_bg_color #${colors.base03};
              @define-color theme_fg_color #${colors.base05};
              @define-color error_bg_color #${colors.base08};
              @define-color error_fg_color #${colors.base05};

              * {
                all: unset;
              }

              .box-wrapper {
                box-shadow:
                  0 19px 38px rgba(0, 0, 0, 0.3),
                  0 15px 12px rgba(0, 0, 0, 0.22);
                background: @window_bg_color;
                padding: 8px;
                border-radius: 8px;
                border: 1px solid @accent_bg_color;
              }

              .preview-box,
              .elephant-hint,
              .placeholder {
                color: @theme_fg_color;
              }

              .search-container {
                border-radius: 8px;
              }

              .input placeholder {
                opacity: 0.5;
              }

              .input selection {
                background: alpha(@accent_bg_color, 0.5);
              }

              .input {
                caret-color: @theme_fg_color;
                background: alpha(@accent_bg_color, 0.25);
                padding: 10px;
                color: @theme_fg_color;
                border-radius: 8px;
              }

              scrollbar {
                opacity: 0;
              }

              .list {
                color: @theme_fg_color;
              }

              .item-box {
                border-radius: 8px;
                padding: 8px;
                min-height: 32px;
              }

              .item-quick-activation {
                background: alpha(@accent_bg_color, 0.25);
                border-radius: 4px;
                padding: 8px;
              }

              child:selected .item-box {
                background: alpha(@accent_bg_color, 0.25);
              }

              .item-subtext {
                font-size: 12px;
                opacity: 0.5;
              }

              .normal-icons {
                -gtk-icon-size: 16px;
              }

              .large-icons {
                -gtk-icon-size: 32px;
              }

              .preview {
                border: 1px solid alpha(@accent_bg_color, 0.25);
                border-radius: 8px;
                color: @theme_fg_color;
              }

              .error {
                padding: 10px;
                background: @error_bg_color;
                color: @error_fg_color;
              }
            ''
          );
        };
      };
}

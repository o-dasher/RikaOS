{
  lib,
  config,
  pkgs,
  ...
}:
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
          themes.stylix.style =
            let
              inherit (config.lib.stylix) colors;
              opacity = toString config.stylix.opacity.popups;
            in
            config.rika.utils.css.tailwindCSS # css
              ''
                @define-color base00 #${colors.base00};
                @define-color base03 #${colors.base03};
                @define-color base05 #${colors.base05};
                @define-color base08 #${colors.base08};

                @tailwind utilities;

                * {
                  all: unset;
                }

                .box-wrapper {
                  box-shadow:
                    0 19px 38px rgba(0, 0, 0, 0.3),
                    0 15px 12px rgba(0, 0, 0, 0.22);
                  background: alpha(@base00, ${opacity});
                  @apply p-2 rounded-lg;
                  border: 1px solid @base03;
                }

                .preview-box,
                .elephant-hint,
                .placeholder {
                  color: @base05;
                }

                .search-container {
                  @apply rounded-lg;
                }

                .input placeholder {
                  @apply opacity-50;
                }

                .input selection {
                  background: alpha(@base03, 0.5);
                }

                .input {
                  caret-color: @base05;
                  background: alpha(@base03, 0.25);
                  color: @base05;
                  @apply p-2.5 rounded-lg;
                }

                scrollbar {
                  @apply opacity-0;
                }

                .list {
                  color: @base05;
                }

                .item-box {
                  @apply rounded-lg p-2 min-h-8;
                }

                .item-quick-activation {
                  background: alpha(@base03, 0.25);
                  @apply rounded p-2;
                }

                child:selected .item-box {
                  background: alpha(@base03, 0.25);
                }

                .item-subtext {
                  @apply text-xs opacity-50;
                }

                .normal-icons {
                  -gtk-icon-size: 16px;
                }

                .large-icons {
                  -gtk-icon-size: 32px;
                }

                .preview {
                  border: 1px solid alpha(@base03, 0.25);
                  color: @base05;
                  @apply rounded-lg;
                }

                .error {
                  background: @base08;
                  color: @base05;
                  @apply p-2.5;
                }
              '';
        };
      };
}

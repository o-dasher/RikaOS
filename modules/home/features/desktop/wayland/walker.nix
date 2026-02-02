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
        home.packages = [ pkgs.app2unit ];
        programs.walker = {
          enable = true;
          runAsService = true;
          config = {
            theme = "stylix";
            list.max_entries = 10;
            terminal = lib.getExe pkgs.xdg-terminal-exec;
          };
          themes.stylix.style =
            config.rika.utils.css.tailwindCSS # css
              ''
                @tailwind utilities;

                * {
                  all: unset;
                }

                .box-wrapper {
                  @apply p-2 rounded-lg bg-base00/${
                    lib.toString ((builtins.floor (config.stylix.opacity.desktop * 100)) + 30)
                  } border border-solid border-base03;
                }

                .preview-box,
                .elephant-hint,
                .placeholder,
                .list,
                .preview {
                  @apply text-base05;
                }

                .search-container {
                  @apply rounded-md;
                }

                .input placeholder {
                  @apply opacity-50;
                }

                .input selection {
                  @apply bg-base03/50;
                }

                .input {
                  @apply p-2.5 rounded-md text-base05 caret-base05 bg-base03/25;
                }

                scrollbar {
                  @apply opacity-0;
                }

                .item-box {
                  @apply rounded-md p-2 min-h-8;
                }

                .item-quick-activation {
                  @apply rounded-md p-2 bg-base03/25;
                }

                child:selected .item-box {
                  @apply bg-base03/25;
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
                  @apply rounded-md border border-base03/25;
                }

                .error {
                  @apply p-2.5 bg-base08 text-base05;
                }
              '';
        };
      };
}

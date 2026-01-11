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
              opacity = toString (builtins.floor (config.stylix.opacity.popups * 100));
            in
            config.rika.utils.css.tailwindCSS # css
              ''
                @tailwind base;
                @tailwind utilities;
                @tailwind components;

                * {
                  all: unset;
                }

                .box-wrapper {
                  @apply p-2 rounded-lg bg-base00/${opacity} border border-solid border-base03;
                }

                .preview-box,
                .elephant-hint,
                .placeholder,
                .list,
                .preview {
                  @apply text-base05;
                }

                .search-container {
                  @apply rounded-lg;
                }

                .input placeholder {
                  @apply opacity-50;
                }

                .input selection {
                  @apply bg-base03/50;
                }

                .input {
                  @apply p-2.5 rounded-lg text-base05 caret-base05 bg-base03/25;
                }

                scrollbar {
                  @apply opacity-0;
                }

                .item-box {
                  @apply rounded-lg p-2 min-h-8;
                }

                .item-quick-activation {
                  @apply rounded p-2 bg-base03/25;
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
                  @apply rounded-lg border border-base03/25;
                }

                .error {
                  @apply p-2.5 bg-base08 text-base05;
                }
              '';
        };
      };
}

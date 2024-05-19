{ ... }:
let
  inherit (import ../utils/default.nix)
    theme
    alpha_fn
    shade_fn
    font_definition
    ;
in
{
  services.swaync = {
    enable = true;
    settings =
      let
        margin = 20;
      in
      {
        positionX = "right";
        positionY = "top";
        layer = "overlay";

        control-center-margin-top = margin;
        control-center-margin-right = margin;
        control-center-width = 400;
        control-center-height = 500;

        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-window-width = 440;

        timeout = 3;
        timeout-low = 2;
        timeout-critical = 0;

        fit-to-screen = false;
        keyboard-shortcuts = true;

        image-visibility = "when-available";
        transition-time = 200;

        hide-on-clear = true;
        hide-on-action = true;
        script-fail-notify = true;

        widgets = [
          "title"
          "dnd"
          "notifications"
        ];

        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd.text = "Do not disturb";
          label = {
            max-lines = 1;
            text = "Notification";
          };
        };
      };
    style = ''
      * {
        ${font_definition}
        font-weight: bold;
        color: ${theme.text_color};
      }

      .control-center {
        background: ${theme.bg_color};
        border-radius: 15;
        border: 2 solid ${theme.selected_bg_color};
        padding: 15;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        padding: 10;
      }

      .notification-content {
        background: ${theme.bg_color};
        border: 2 solid ${theme.selected_bg_color};
        padding: 4;
        border-radius: 4;
      }

      .close-button
      .notification-action {
        margin-right: 10;
      }

      .summary,
      .time {
      	font-size: 12;
      }

      .time {
        margin-right: 32;
      }

      .floating-notifications,
      .blank-window {
        background: transparent;
      }

      .widget-title,
      .widget-dnd {
        background: ${alpha_fn theme.selected_bg_color 0.25};
        padding: 5;
        font-size: 1.5rem;
        border-radius: 4;
      }

      .widget-title > button {
        font-size: 1rem;
        background: ${alpha_fn theme.bg_color 0.5};
        border-radius: 4;
        padding: 4;
      }

      .widget-title > button:hover {
        background: ${theme.bg_color};
      }

      .widget-dnd > switch {
        border-radius: 4;
        background: ${theme.bg_color};
      }

      .widget-dnd > switch:checked {
        background: ${shade_fn theme.selected_bg_color 0.5};
      }

      .widget-dnd > switch slider {
        background: ${shade_fn theme.bg_color 1.25};
        border-radius: 4;
      }
    '';
  };
}

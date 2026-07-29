# Note: Always prefer flattened attribute syntax (e.g. services.wayle.settings.bar.padding)
# when there are no multiple nested attributes to keep module configurations concise.
{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  modCfg = config.features.desktop.wayland;
  cfg = modCfg.wayle;
  hasStylix = options ? stylix;
in
with lib;
{
  options.features.desktop.wayland.wayle.enable = (mkEnableOption "wayle") // {
    default = true;
  };

  config = mkIf (hasStylix && config.features.desktop.enable && modCfg.enable && cfg.enable) {
    services.wayle.enable = true;

    services.wayle.settings.general = {
      font-sans = mkForce config.stylix.fonts.sansSerif.name;
      font-mono = mkForce config.stylix.fonts.monospace.name;
    };

    services.wayle.settings.bar = {
      layer = "top";
      location = "top";
      scale = 1.0;
      padding = 0.25;
      padding-ends = 0.35;
      inset-edge = 0.0;
      inset-ends = 0.0;
      module-gap = 0.5;
      button-group-module-gap = 0.0;
      button-group-border-color = "border-accent";
      button-group-border-location = "all";
      button-group-border-width = 1;
      button-group-rounding = "none";
      button-border-location = "right";
      button-border-width = 1;
      button-rounding = "none";
      button-label-size = 0.8;
      button-icon-size = 0.8;
      button-label-padding = 0.4;
      button-icon-padding = 0.25;
      button-gap = 0.25;

      layout = [
        {
          monitor = "*";
          left = optionals config.features.desktop.hyprland.enable [
            {
              name = "modules-left";
              modules = [
                "hyprland-workspaces"
              ];
            }
          ];
          center = [
            {
              name = "modules-center";
              modules = [
                "clock"
              ];
            }
          ];
          right = [
            {
              name = "modules-right";
              modules = [
                "custom-cpu-temp"
                "custom-gpu-temp"
                "cpu"
                "ram"
                "systray"
                "volume"
                "microphone"
              ];
            }
          ];
        }
      ];
    };

    services.wayle.settings.modules = {
      clock = {
        format = "%H:%M | %a %b %d";
        icon-show = true;
        border-show = true;
        border-color = "border-accent";
      };

      hyprland-workspaces = mkIf config.features.desktop.hyprland.enable {
        min-workspace-count = 10;
        monitor-specific = false;
        show-special = true;
        display-mode = "label";
        numbering = "absolute";
        label-size = 0.8;
        workspace-padding = 0.35;
        active-indicator = "background";
        active-color = "accent";
        occupied-color = "fg-default";
        empty-color = "fg-subtle";
        container-bg-color = "transparent";
        border-show = false;
        workspace-map."10".label = "0";
      };

      cpu = {
        format = "  {{ percent }}%";
        icon-show = false;
        border-show = true;
        border-color = "border-accent";
      };

      ram = {
        poll-interval-ms = 30000;
        format = "  {{ used_gib }}GB";
        icon-show = false;
        border-show = true;
        border-color = "border-accent";
      };

      systray = {
        icon-scale = 0.8;
        item-gap = 0.15;
        border-show = true;
        border-color = "border-accent";
      };

      microphone = {
        left-click = getExe pkgs.pwvucontrol;
        border-show = true;
        border-color = "border-accent";
      };

      volume = {
        left-click = getExe pkgs.pwvucontrol;
        scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        border-show = true;
        border-color = "border-accent";
      };

      custom = [
        {
          id = "cpu-temp";
          mode = "poll";
          poll-interval-ms = 2000;
          command = "cat /sys/bus/pci/devices/0000:00:18.3/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 | awk '{printf \"CPU %.0f°C\", $1/1000}'";
          format = "{{ output }}";
          icon-show = false;
          border-show = true;
          border-color = "border-accent";
        }
        {
          id = "gpu-temp";
          mode = "poll";
          poll-interval-ms = 2000;
          command = "cat /sys/bus/pci/devices/0000:03:00.0/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 | awk '{printf \"GPU %.0f°C\", $1/1000}'";
          format = "{{ output }}";
          icon-show = false;
          border-show = true;
          border-color = "border-accent";
        }
      ];
    };

    # Fixes blurry and antialiased rendering on Wayle.
    systemd.user.services.wayle.Service.Environment = [ "GSK_RENDERER=cairo" ];
  };
}

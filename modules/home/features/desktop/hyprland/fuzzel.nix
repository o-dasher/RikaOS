{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.desktop.hyprland.fuzzel.enable = (lib.mkEnableOption "fuzzel") // {
    default = true;
  };

  config =
    lib.mkIf (config.features.desktop.hyprland.enable && config.features.desktop.hyprland.fuzzel.enable)
      {
        home.packages = [
          config.stylix.iconTheme.package
        ];
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              terminal = lib.getExe pkgs.xdg-terminal-exec;
              launch-prefix = "${lib.getExe pkgs.app2unit} --fuzzel-compat --";

              icon-theme = config.stylix.iconTheme.${config.stylix.polarity};
              font = lib.mkForce "JetbrainsMono:size=16";

              width = 40;
              lines = 10;
              line-height = 24;
            };

            border = {
              width = 2;
              radius = 0;
            };
          };
        };
      };
}

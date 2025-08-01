{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.desktop.hyprland.fuzzel.enable = (lib.mkEnableOption "fuzzel") // {
    default = true;
  };

  config = lib.mkIf (config.desktop.hyprland.enable && config.desktop.hyprland.fuzzel.enable) {
    home.packages = [
      config.stylix.iconTheme.package
    ];
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = lib.getExe pkgs.xdg-terminal-exec;

          icon-theme = config.stylix.iconTheme.${config.stylix.polarity};
          font = lib.mkForce "JetbrainsMono:size=16";

          width = 40;
          lines = 10;
          line-height = 24;
        };
      };
    };
  };
}

{
  lib,
  config,
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
          font = lib.mkForce "JetbrainsMono:size=16";
          width = 48;
          icon-theme = config.stylix.iconTheme.${config.stylix.polarity};
        };
      };
    };
  };
}

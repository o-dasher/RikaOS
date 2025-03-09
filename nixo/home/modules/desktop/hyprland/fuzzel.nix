{ lib, config, ... }:
{
  options.desktop.hyprland.fuzzel.enable = (lib.mkEnableOption "fuzzel") // {
    default = true;
  };

  config.programs.fuzzel =
    lib.mkIf (config.desktop.hyprland.enable && config.desktop.hyprland.fuzzel.enable)
      {
        enable = true;
        settings = {
          main = {
            font = lib.mkForce "JetbrainsMono:size=16";
            width = 48;
          };
        };
      };
}

{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland desktop";
  };

  config = lib.mkIf config.features.desktop.hyprland.enable {
    programs = {
      # BUG: workaround https://github.com/hyprwm/Hyprland/discussions/12661
      uwsm.waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };
}

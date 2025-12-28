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
    # We don't want to wait for way too long.
    systemd.user.extraConfig = # ini
      ''
        DefaultTimeoutStopSec=3s
        DefaultTimeoutStartSec=3s
      '';

    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "3s";
      DefaultTimeoutStartSec = "3s";
    };

    programs = {
      # BUG: workaround https://github.com/hyprwm/Hyprland/discussions/12661
      uwsm.waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";

      hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };
  };
}

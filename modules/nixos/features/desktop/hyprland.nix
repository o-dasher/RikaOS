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
      uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/start-hyprland";
          };
        };
      };

      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };
  };
}

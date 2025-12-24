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
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Enable GDM by default when Hyprland is enabled, but allow it to be disabled if user wants another DM
    features.desktop.displayManager.gdm.enable = lib.mkDefault true;
  };
}

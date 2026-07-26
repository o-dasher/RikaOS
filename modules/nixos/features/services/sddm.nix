{
  pkgs,
  lib,
  config,
  themeLib,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.sddm;
in
with lib;
{
  imports = [
    ../../../lib
  ];

  options.features.services.sddm = {
    enable = mkEnableOption "SDDM Display Manager";
    background = mkOption {
      type = types.path;
      description = "Background image for SDDM";
    };
    flavor = mkOption {
      type = types.str;
      description = "Catppuccin flavor for SDDM (e.g., mocha, latte)";
    };
    accent = mkOption {
      type = types.str;
      description = "Catppuccin accent color for SDDM (e.g., mauve, pink)";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) {
    environment.systemPackages = [
      themeLib.cursor.package
      (pkgs.catppuccin-sddm.override {
        inherit (cfg) accent flavor;
        background = "${cfg.background}";
        loginBackground = true;
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
      settings.Theme = {
        CursorTheme = themeLib.cursor.name;
        CursorSize = toString themeLib.cursor.size;
      };
      wayland = {
        enable = true;
        compositorCommand =
          let
            sddmConfig = ../../../../dotfiles/hypr/sddm.lua;
          in
          "env HYPRLAND_CONFIG=${sddmConfig} start-hyprland";
      };
    };
  };
}

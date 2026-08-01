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
{
  imports = [
    ../../../lib
  ];

  options.features.services.sddm = {
    enable = lib.mkEnableOption "SDDM Display Manager";
    background = lib.mkOption {
      type = lib.types.path;
      description = "Background image for SDDM";
    };
    flavor = lib.mkOption {
      type = lib.types.str;
      description = "Catppuccin flavor for SDDM (e.g., mocha, latte)";
    };
    accent = lib.mkOption {
      type = lib.types.str;
      description = "Catppuccin accent color for SDDM (e.g., mauve, pink)";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    environment.systemPackages = [
      themeLib.cursor.package
      (pkgs.catppuccin-sddm.override {
        inherit (cfg) accent flavor;
        background = "${cfg.background}";
        loginBackground = true;
      })
    ];

    # WORKAROUND: Fix non-functioning TTY switching under Hyprland.
    # Hyprland forwards VT switch requests to systemd-logind via DBus
    # (org.freedesktop.login1.chvt). Logind denies these requests by default
    # for SDDM's greeter session and unprivileged users, causing Ctrl+Alt+Fx
    # shortcuts to fail. This rule permits VT switching for SDDM and regular users (UID >= 1000).
    security.polkit.extraConfig = # js
      ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.login1.chvt" || action.id == "org.freedesktop.login1.chvt-own-session") &&
              (subject.user == "sddm" || subject.uid >= 1000)) {
            return polkit.Result.YES;
          }
        });
      '';

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
          #bash
          "start-hyprland -- --config ${sddmConfig}";
      };
    };
  };
}

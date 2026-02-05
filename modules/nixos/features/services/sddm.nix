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

  config = mkIf (modCfg.enable && cfg.enable) {
    environment.systemPackages = [
      themeLib.cursor.package
      (pkgs.catppuccin-sddm.override {
        flavor = cfg.flavor;
        accent = cfg.accent;
        background = "${cfg.background}";
        loginBackground = true;
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
      wayland = {
        enable = true;
        compositorCommand =
          let
            config =
              pkgs.writeText "hyprland-sddm.conf" # hyprlang
                ''
                  monitor = , highres@highrr, auto, 1

                  animations {
                    enabled = false
                  }

                  misc {
                    disable_hyprland_logo = true
                    disable_splash_rendering = true
                  }

                  exec-once = hyprctl setcursor ${themeLib.cursor.name} ${toString themeLib.cursor.size}
                '';
          in
          "env HYPRLAND_CONFIG=${config} start-hyprland";
      };
    };
  };
}

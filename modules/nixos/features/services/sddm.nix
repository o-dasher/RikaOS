{
  pkgs,
  lib,
  config,
  themeLib,
  ...
}:
let
  cfg = config.features.services.sddm;
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

  config = lib.mkIf cfg.enable {
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

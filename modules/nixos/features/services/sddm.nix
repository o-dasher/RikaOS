{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.services.sddm;
in
{
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
      (pkgs.catppuccin-sddm.override {
        flavor = cfg.flavor;
        accent = cfg.accent;
        background = "${cfg.background}";
        loginBackground = true;
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
      theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
    };
  };
}

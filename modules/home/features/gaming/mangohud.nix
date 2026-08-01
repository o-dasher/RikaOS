{
  lib,
  config,
  ...
}:
let
  cfg = config.features.gaming.mangohud;
in
{
  options.features.gaming.mangohud.enable = lib.mkEnableOption "mangohud";

  config = lib.mkIf (config.features.gaming.enable && cfg.enable) {
    programs.mangohud = {
      enable = true;
      settings = {
        preset = 1;
        toggle_hud = "Control_L+Shift_L";
      };
    };
  };
}

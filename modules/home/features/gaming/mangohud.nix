{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.mangohud;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.mangohud = {
      enable = true;
      settings = {
        preset = 1;
        toggle_hud = "Control_L+Shift_L";
      };
    };
  };
}

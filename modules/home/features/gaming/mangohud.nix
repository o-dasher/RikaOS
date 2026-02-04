{
  lib,
  config,
  ...
}:
{
  options.features.gaming.mangohud.enable = lib.mkEnableOption "mangohud";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.mangohud.enable) {
    programs.mangohud = {
      enable = true;
      settings = {
        preset = 1;
        toggle_hud = "Control_L+Shift_L";
      };
    };
  };
}

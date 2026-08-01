{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.development.godot;
in
{
  options.features.development.godot.enable = lib.mkEnableOption "godot";

  config = lib.mkIf (config.features.development.enable && cfg.enable) {
    home.packages = [ pkgs.godot ];
  };
}

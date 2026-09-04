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
  options.features.development.godot.enable =
    lib.mkEnableOption "Godot Engine 4 game development package";

  config = lib.mkIf (config.features.development.enable && cfg.enable) {
    home.packages = [ pkgs.godot ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.development;
  cfg = modCfg.godot;
in
with lib;
{
  options.features.development.godot.enable = mkEnableOption "godot";

  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.godot ];
  };
}

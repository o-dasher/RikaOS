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
  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.godot ];
  };
}

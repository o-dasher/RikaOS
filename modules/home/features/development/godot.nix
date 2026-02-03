{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.dev.godot.enable = lib.mkEnableOption "godot";

  config = lib.mkIf config.features.dev.godot.enable {
    home.packages = [ pkgs.godot ];
  };
}

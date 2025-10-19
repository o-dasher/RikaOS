{ lib, config, pkgs, ... }:
{
  options.dev.godot.enable = lib.mkEnableOption "godot";

  config = lib.mkIf config.dev.godot.enable {
    home.packages = [ pkgs.godot ];
  };
}

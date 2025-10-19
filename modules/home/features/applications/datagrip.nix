{ lib, config, pkgs, ... }:
{
  options.applications.datagrip.enable = lib.mkEnableOption "datagrip";

  config = lib.mkIf config.applications.datagrip.enable {
    home.packages = [ pkgs.jetbrains.datagrip ];
  };
}

{ pkgs, lib, config, ... }:
{
  options.suites.productivity = {
    enable = lib.mkEnableOption "productivity suite";
  };

  config = lib.mkIf config.suites.productivity.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}

{ pkgs, lib, config, ... }:
{
  options.profiles.productivity = {
    enable = lib.mkEnableOption "productivity profile";
  };

  config = lib.mkIf config.profiles.productivity.enable {
    home.packages = with pkgs; [
      # bitwarden-desktop moved to security profile
    ];
  };
}

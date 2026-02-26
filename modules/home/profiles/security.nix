{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.security;
in
with lib;
{
  options.profiles.security.enable = mkEnableOption "security profile";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}

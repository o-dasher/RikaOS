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
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}

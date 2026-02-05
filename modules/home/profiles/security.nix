{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.profiles.security;
in
with lib;
{
  config = mkIf modCfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}

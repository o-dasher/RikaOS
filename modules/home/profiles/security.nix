{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.security;
in
{
  options.profiles.security.enable = lib.mkEnableOption "security profile";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ bitwarden-desktop ];
  };
}

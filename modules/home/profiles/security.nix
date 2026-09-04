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
  options.profiles.security.enable = lib.mkEnableOption "desktop security profile (Bitwarden password manager desktop client)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ bitwarden-desktop ];
  };
}

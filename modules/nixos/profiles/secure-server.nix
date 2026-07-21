{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.secureServer;
in
with lib;
{
  options.profiles.secureServer.enable = mkEnableOption "secure server profile";

  config = mkIf cfg.enable {
    services = {
      fail2ban = {
        enable = true;
        bantime = "24h";
      };
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}

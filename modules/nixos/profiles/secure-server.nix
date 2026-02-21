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
  config = mkIf cfg.enable {
    features.services.tailscale = {
      enable = true;
      trust = true;
    };

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

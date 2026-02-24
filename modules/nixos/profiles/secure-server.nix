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
        ignoreIP =
          let
            tailscaleIP = "100.64.0.0/16";
          in
          [ tailscaleIP ];
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

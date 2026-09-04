{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.secureServer;
in
{
  options.profiles.secureServer.enable = lib.mkEnableOption "secure server profile with hardened OpenSSH and fail2ban intrusion prevention";

  config = lib.mkIf cfg.enable {
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

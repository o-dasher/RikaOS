{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.secureServer;
in
{
  options.profiles.secureServer.enable = lib.mkEnableOption "Secure server profile.";

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

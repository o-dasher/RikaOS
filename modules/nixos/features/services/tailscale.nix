{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.tailscale;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable && config.age.secrets ? tailscale-auth-key) (mkMerge [
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.age.secrets.tailscale-auth-key.path;
        extraUpFlags = [
          "--accept-dns=true"
          "--hostname=${config.networking.hostName}"
        ];
      };
    }
    (mkIf cfg.dnsFirewall.enable {
      networking.firewall.interfaces."tailscale0" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
    })
    (mkIf cfg.dnsServer.enable {
      services.coredns = {
        enable = true;
        config = ''
          ${cfg.dnsServer.zone}:53 {
            errors
            log
            bind ${cfg.dnsServer.tailnetIP}
            hosts {
              ${cfg.dnsServer.tailnetIP} ${lib.concatStringsSep " " cfg.dnsServer.hosts}
              fallthrough
            }
            forward . ${lib.concatStringsSep " " cfg.dnsServer.forwarders}
          }
        '';
      };
    })
  ]);
}

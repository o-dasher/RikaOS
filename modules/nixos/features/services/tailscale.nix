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
  options.features.services.tailscale = {
    enable = mkEnableOption "tailscale";
    trust = mkEnableOption "Trusts tailscale inteface on the firewall";
    dns.server = {
      enable = mkEnableOption "CoreDNS on tailscale with host list";
      zone = mkOption {
        type = types.str;
        description = "DNS zone CoreDNS will serve on tailscale";
      };
      tailnetIP = mkOption {
        type = types.str;
        description = "Tailscale IP to bind and return for hosts";
      };
      hosts = mkOption {
        type = types.listOf types.str;
        description = "Hostnames to resolve to tailnetIP in the zone";
        default = [ ];
      };
      forwarders = mkOption {
        type = types.listOf types.str;
        description = "Upstream resolvers for other queries in the zone";
        default = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };

  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) (mkMerge [
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.age.secrets.tailscale-auth-key.path;
      };
    }
    (mkIf cfg.trust {
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    })
    (mkIf cfg.dns.server.enable {
      services.coredns = {
        enable = true;
        config = ''
          ${cfg.dns.server.zone}:53 {
            errors
            log
            bind ${cfg.dns.server.tailnetIP}
            hosts {
              ${cfg.dns.server.tailnetIP} ${lib.concatStringsSep " " cfg.dns.server.hosts}
              fallthrough
            }
            forward . ${lib.concatStringsSep " " cfg.dns.server.forwarders}
          }
        '';
      };
    })
  ]);
}

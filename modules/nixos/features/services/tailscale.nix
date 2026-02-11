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

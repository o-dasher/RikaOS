{
  lib,
  config,
  ...
}:
let
  cfg = config.features.networking;
in
with lib;
{
  options.features.networking.cloudflare = {
    warp.enable = mkEnableOption "Warp";
    dns.enable = mkEnableOption "DNS";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.cloudflare-warp.enable = cfg.cloudflare.warp.enable;
    }
    (mkIf cfg.cloudflare.dns.enable {
      services =
        let
          dnsAddress = "127.0.0.1";
          dohPort = 5053;
        in
        {
          resolved = {
            enable = true;
            settings.Resolve.DNS = [ "${dnsAddress}:${toString dohPort}" ];
          };
          https-dns-proxy = {
            enable = true;
            address = dnsAddress;
            port = dohPort;
            provider.kind = "cloudflare";
          };
        };
    })
  ]);
}

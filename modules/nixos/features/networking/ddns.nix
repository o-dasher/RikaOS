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
  options.features.networking.ddns = {
    enable = mkEnableOption "Cloudflare DDNS";
    domains = mkOption {
      type = types.listOf types.str;
      description = "DNS records to update (for example host.example.com)";
    };
    zone = mkOption {
      type = types.str;
      description = "Cloudflare zone name (for example example.com)";
    };
    useWebIPv6 = mkOption {
      type = types.bool;
      description = "Use webv6 lookup instead of interface address for DDNS";
    };
    updateIPv4 = mkOption {
      type = types.bool;
      description = "Whether to update IPv4 (A) records as well";
    };
  };

  config = mkIf (cfg.enable && cfg.ddns.enable && config.age.secrets ? cloudflare-ddns-token) {
    services.ddclient = {
      enable = true;
      inherit (cfg.ddns) domains zone;
      username = "token";
      passwordFile = config.age.secrets.cloudflare-ddns-token.path;
      protocol = "cloudflare";
      server = "api.cloudflare.com/client/v4";
      usev4 = if cfg.ddns.updateIPv4 then "webv4, webv4=ipify-ipv4" else "";
      usev6 = if cfg.ddns.useWebIPv6 then "webv6, webv6=ipify-ipv6" else "ifv6, ifv6=${cfg.primaryInterface}";
    };
  };
}

{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.networking;
  cfg = modCfg.ddns;
in
{
  options.features.networking.ddns = {
    enable = lib.mkEnableOption "Cloudflare DDNS";
    domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "DNS records to update (for example host.example.com)";
    };
    zone = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare zone name (for example example.com)";
    };
    useWebIPv6 = lib.mkOption {
      type = lib.types.bool;
      description = "Use webv6 lookup instead of interface address for DDNS";
    };
    updateIPv4 = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to update IPv4 (A) records as well";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) {
    services.ddclient = {
      enable = true;
      inherit (cfg) domains zone;
      username = "token";
      passwordFile = config.age.secrets.cloudflare-ddns-token.path;
      protocol = "cloudflare";
      server = "api.cloudflare.com/client/v4";
      usev4 = if cfg.updateIPv4 then "webv4, webv4=ipify-ipv4" else "";
      usev6 =
        if cfg.useWebIPv6 then "webv6, webv6=ipify-ipv6" else "ifv6, ifv6=${modCfg.primaryInterface}";
    };
  };
}

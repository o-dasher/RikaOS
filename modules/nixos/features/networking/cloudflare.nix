{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.networking;
  cf = cfg.cloudflare;
in
{
  options.features.networking.cloudflare = {
    warp.enable = lib.mkEnableOption "Warp";
    dns.enable = lib.mkEnableOption "DNS";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.cloudflare-warp = {
          enable = cf.warp.enable;
          package = pkgs.cloudflare-warp.override { headless = true; };
        };
      }
      (lib.mkIf cf.dns.enable {
        services = {
          resolved = {
            enable = true;
            settings.Resolve = {
              DNS = [ "127.0.0.1:5053" ];
              Domains = [ "~." ];
              FallbackDNS = [
                "1.1.1.1#one.one.one.one"
                "1.0.0.1#one.one.one.one"
                "2606:4700:4700::1111#one.one.one.one"
                "2606:4700:4700::1001#one.one.one.one"
              ];
            };
          };
          https-dns-proxy = {
            enable = true;
            address = "127.0.0.1";
            port = 5053;
            provider.kind = "cloudflare";
          };
        };
      })
    ]
  );
}

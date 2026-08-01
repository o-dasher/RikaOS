{
  lib,
  config,
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.cloudflare-warp.enable = cf.warp.enable;
    }
    (lib.mkIf cf.dns.enable {
      services = {
        resolved = {
          enable = true;
          settings.Resolve.DNS = [ "127.0.0.1:5053" ];
        };
        https-dns-proxy = {
          enable = true;
          address = "127.0.0.1";
          port = 5053;
          provider.kind = "cloudflare";
        };
      };
    })
  ]);
}

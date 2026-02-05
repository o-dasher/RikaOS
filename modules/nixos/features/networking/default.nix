{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.networking;
in
with lib;
{
  options.features.networking = {
    enable = mkEnableOption "networking";
    privacyIPv6.enable = mkEnableOption "Privacy IPv6 address generation";
    primaryInterface = mkOption {
      type = types.str;
      description = "The network interface to match against";
    };
    cloudflare = {
      warp.enable = mkEnableOption "Warp";
      dns.enable = mkEnableOption "DNS";
    };
    ddns = {
      enable = mkEnableOption "Cloudflare DDNS";
      domains = mkOption {
        type = types.listOf types.str;
        description = "DNS records to update (e.g., host.example.com)";
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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      networking.useNetworkd = true;
      services.cloudflare-warp.enable = cfg.cloudflare.warp.enable;
      systemd.network = {
        enable = true;
        networks."99-network" = mkMerge [
          {
            matchConfig.Name = cfg.primaryInterface;
            networkConfig = {
              DHCP = "ipv4";
              IPv6AcceptRA = true;
            };
          }
          (mkIf cfg.privacyIPv6.enable {
            networkConfig = {
              IPv6LinkLocalAddressGenerationMode = "stable-privacy";
              IPv6PrivacyExtensions = "yes";
            };
          })
          (mkIf cfg.cloudflare.dns.enable {
            dhcpV4Config.UseDNS = false;
            ipv6AcceptRAConfig.UseDNS = false;
          })
        ];
      };
    }

    (mkIf cfg.cloudflare.dns.enable {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNS = [ "127.0.0.1:5053" ];
          FallbackDNS = [ ];
        };
      };
      systemd = {
        services.cloudflared-doh = {
          description = "Cloudflare DNS over HTTPS proxy";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.cloudflared} proxy-dns --port 5053";
            Restart = "on-failure";
            DynamicUser = true;
          };
        };
      };
    })

    (mkIf (cfg.ddns.enable && config.age.secrets ? cloudflare-ddns-token) {
      services.cloudflare-ddns = {
        enable = true;
        inherit (cfg.ddns) domains;
        credentialsFile = config.age.secrets.cloudflare-ddns-token.path;
        provider = {
          ipv4 = if cfg.ddns.updateIPv4 then "cloudflare.trace" else "none";
          ipv6 =
            if cfg.ddns.useWebIPv6 then
              "cloudflare.trace"
            else if cfg.privacyIPv6.enable then
              "local.iface:${cfg.primaryInterface}"
            else
              "local";
        };
      };
    })
  ]);
}

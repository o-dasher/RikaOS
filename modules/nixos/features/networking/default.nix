{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.networking;
  stableIPv6Cfg = cfg.stableIPv6;
in
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    networkManager.enable = lib.mkEnableOption "NetworkManager";
    cloudflare = {
      warp.enable = lib.mkEnableOption "Warp";
      dns.enable = lib.mkEnableOption "DNS";
    };
    stableIPv6 = {
      enable = lib.mkEnableOption "stable IPv6 address with systemd-networkd";
      ipv6 = lib.mkOption {
        type = lib.types.str;
        default = "NOT_SET";
        description = "The static ipv6 address to use";
      };
      interface = lib.mkOption {
        type = lib.types.str;
        default = "10-lan";
        description = "Network name for systemd-networkd";
      };
      matchInterface = lib.mkOption {
        type = lib.types.str;
        description = "Physical interface name to match (e.g., enp6s0)";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.networkmanager.enable = cfg.networkManager.enable;
        services.cloudflare-warp.enable = cfg.cloudflare.warp.enable;
      }

      (lib.mkIf cfg.cloudflare.dns.enable {
        services.resolved = {
          enable = true;
          settings.Resolve = {
            DNS = [ "127.0.0.1:5053" ];
            FallbackDNS = [ ];
          };
        };
        systemd.services = {
          cloudflared-doh = {
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
          cloudflare-warp = lib.mkIf cfg.cloudflare.warp.enable {
            after = [ "cloudflared-doh.service" ];
            wants = [ "cloudflared-doh.service" ];
          };
        };
      })

      (lib.mkIf stableIPv6Cfg.enable {
        networking = {
          useDHCP = false;
          useNetworkd = true;
        };
        systemd.network = {
          enable = true;
          networks.${stableIPv6Cfg.interface} = {
            matchConfig.Name = stableIPv6Cfg.matchInterface;
            address = [ "${stableIPv6Cfg.ipv6}/64" ];
            networkConfig = {
              DHCP = "ipv4";
              IPv6AcceptRA = true;
              IPv6LinkLocalAddressGenerationMode = "stable-privacy";
            };
            dhcpV4Config = lib.mkIf cfg.cloudflare.dns.enable {
              UseDNS = false;
            };
            ipv6AcceptRAConfig = lib.mkIf cfg.cloudflare.dns.enable {
              UseDNS = false;
            };
          };
        };
      })
    ]
  );
}

{
  lib,
  config,
  ...
}:
let
  cfg = config.features.networking;
  stableIPv6Cfg = cfg.stableIPv6;
in
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    cloudflare.enable = lib.mkEnableOption "Cloudflare";
    networkManager.enable = lib.mkEnableOption "NetworkManager";
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
      }

      (lib.mkIf cfg.cloudflare.enable {
        services = {
          cloudflare-warp.enable = true;
          resolved = {
            enable = true;
            settings.Resolve.DNSOverTLS = true;
          };
        };
        networking.nameservers = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
          "2606:4700:4700::1001#cloudflare-dns.com"
        ];
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
          };
        };
      })
    ]
  );
}

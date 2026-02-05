{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.networking;
  stableIPv6Cfg = modCfg.stableIPv6;
in
with lib;
{
  options.features.networking = {
    networkManager.enable = mkEnableOption "NetworkManager";
    cloudflare = {
      warp.enable = mkEnableOption "Warp";
      dns.enable = mkEnableOption "DNS";
    };
    stableIPv6 = {
      enable = mkEnableOption "stable IPv6 address with systemd-networkd";
      ipv6 = mkOption {
        type = types.str;
        default = "NOT_SET";
        description = "The static ipv6 address to use";
      };
      interface = mkOption {
        type = types.str;
        default = "10-lan";
        description = "Network name for systemd-networkd";
      };
      matchInterface = mkOption {
        type = types.str;
        description = "Physical interface name to match (e.g., enp6s0)";
      };
    };
    enable = mkEnableOption "networking";
  };

  config = mkIf modCfg.enable (mkMerge [
    {
      networking.networkmanager.enable = modCfg.networkManager.enable;
      services.cloudflare-warp.enable = modCfg.cloudflare.warp.enable;
    }

    (mkIf modCfg.cloudflare.dns.enable {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNS = [ "127.0.0.1:5053" ];
          FallbackDNS = [ ];
        };
      };
      systemd.services.cloudflared-doh = {
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
    })

    (mkIf stableIPv6Cfg.enable {
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
          dhcpV4Config = mkIf modCfg.cloudflare.dns.enable {
            UseDNS = false;
          };
          ipv6AcceptRAConfig = mkIf modCfg.cloudflare.dns.enable {
            UseDNS = false;
          };
        };
      };
    })
  ]);
}

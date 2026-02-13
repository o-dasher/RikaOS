{
  lib,
  config,
  ...
}:
let
  cfg = config.features.networking;
  wgCfg = cfg.wireguard;
in
with lib;
{
  options.features.networking.wireguard = {
    enable = mkEnableOption "WireGuard tunnel";
    interface = mkOption {
      type = types.str;
      default = "wg0";
      description = "WireGuard interface name";
    };
    address = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Local WireGuard address in CIDR notation (for example 10.72.0.2/24)";
    };
    listenPort = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = "WireGuard UDP listen port (server side)";
    };
    privateKeyFile = mkOption {
      type = types.str;
      default = "/var/lib/wireguard/${cfg.wireguard.interface}.key";
      description = "Path to WireGuard private key file";
    };
    generatePrivateKeyFile = mkOption {
      type = types.bool;
      default = true;
      description = "Generate private key file if it does not exist";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall for listenPort when listenPort is set";
    };
    peer = {
      publicKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Peer WireGuard public key";
      };
      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Routes assigned to peer";
      };
      endpoint = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Peer endpoint for client side (for example host:51820)";
      };
      persistentKeepalive = mkOption {
        type = types.nullOr types.int;
        default = 25;
        description = "WireGuard persistent keepalive interval in seconds";
      };
    };
  };

  config = mkIf (wgCfg.enable && wgCfg.address != null && wgCfg.peer.publicKey != null) {
    networking = {
      firewall.allowedUDPPorts = optional (
        wgCfg.openFirewall && wgCfg.listenPort != null
      ) wgCfg.listenPort;
      wireguard = {
        useNetworkd = false;
        interfaces.${wgCfg.interface} = {
          ips = [ wgCfg.address ];
          inherit (wgCfg)
            listenPort
            privateKeyFile
            generatePrivateKeyFile
            ;
          peers = [
            {
              inherit (wgCfg.peer)
                publicKey
                allowedIPs
                endpoint
                persistentKeepalive
                ;
            }
          ];
        };
      };
    };
  };
}

{
  lib,
  config,
  ...
}:
let
  cfg = config.features.networking;
  relayCfg = cfg.nicotineRelay;
  destination =
    if relayCfg.destination != null then
      relayCfg.destination
    else if relayCfg.tunnelIPv4 != null then
      "${relayCfg.tunnelIPv4}:${toString relayCfg.externalPort}"
    else
      null;
in
with lib;
{
  options.features.networking.nicotineRelay = {
    enable = mkEnableOption "Nicotine relay from public interface to tunnel peer";
    externalInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Public interface receiving incoming Nicotine connections";
    };
    tunnelInterface = mkOption {
      type = types.str;
      default = cfg.wireguard.interface;
      description = "Tunnel interface used to forward Nicotine connections";
    };
    tunnelSourceIPv4 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Tunnel source IPv4 used for SNAT on forwarded Nicotine traffic";
    };
    tunnelIPv4 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Tunnel destination IPv4 for forwarded Nicotine traffic";
    };
    externalPort = mkOption {
      type = types.port;
      default = 2234;
      description = "Public TCP port exposed for Nicotine";
    };
    destination = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Forward destination in ip:port format (defaults to tunnelIPv4:externalPort)";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall for externalPort";
    };
  };

  config =
    mkIf
      (
        relayCfg.enable
        && relayCfg.externalInterface != null
        && destination != null
        && relayCfg.tunnelSourceIPv4 != null
      )
      {
        networking = {
          nat = {
            enable = true;
            externalInterface = relayCfg.externalInterface;
            internalInterfaces = [ relayCfg.tunnelInterface ];
            forwardPorts = [
              {
                sourcePort = relayCfg.externalPort;
                proto = "tcp";
                inherit destination;
              }
            ];
          };

          nftables = {
            enable = true;
            tables.nicotine-relay = {
              family = "ip";
              content = ''
                chain postrouting {
                  type nat hook postrouting priority srcnat; policy accept;
                  iifname "${relayCfg.externalInterface}" oifname "${relayCfg.tunnelInterface}" tcp dport ${toString relayCfg.externalPort} snat to ${relayCfg.tunnelSourceIPv4}
                }
              '';
            };
          };

          firewall = {
            checkReversePath = "loose";
          }
          // optionalAttrs relayCfg.openFirewall {
            allowedTCPPorts = [ relayCfg.externalPort ];
          };
        };
      };
}

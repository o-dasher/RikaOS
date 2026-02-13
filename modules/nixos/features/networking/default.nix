{
  lib,
  config,
  nixCaches,
  ...
}:
let
  cfg = config.features.networking;
in
with lib;
{
  imports = [
    ./cloudflare.nix
    ./ddns.nix
    ./wireguard.nix
    ./nicotine-relay.nix
  ];

  options.features.networking = {
    enable = mkEnableOption "networking";
    privacyIPv6.enable = mkEnableOption "Privacy IPv6 address generation";

    primaryInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The network interface to match against";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      nix.settings = nixCaches;
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "/shared/.config/private";
      };
    })

    (mkIf (cfg.enable && cfg.primaryInterface != null) {
      networking.useNetworkd = true;
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
    })
  ];
}

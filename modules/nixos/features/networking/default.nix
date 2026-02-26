{
  lib,
  config,
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
  ];

  options.features.networking = {
    enable = mkEnableOption "networking";
    privacyIPv6.enable = mkEnableOption "Privacy IPv6 address generation";
    primaryInterface = mkOption {
      type = types.str;
      description = "The primary networking interface for operations.";
    };
  };

  config = mkIf cfg.enable {
    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."99-network" = mkMerge [
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
  };
}

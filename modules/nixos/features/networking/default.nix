{
  lib,
  config,
  ...
}:
let
  cfg = config.features.networking;
in
{
  imports = [
    ./cloudflare.nix
    ./ddns.nix
  ];

  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    privacyIPv6.enable = lib.mkEnableOption "Privacy IPv6 address generation";
    primaryInterface = lib.mkOption {
      type = lib.types.str;
      description = "The primary networking interface for operations.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."99-network" = lib.mkMerge [
        (lib.mkIf cfg.privacyIPv6.enable {
          networkConfig = {
            IPv6LinkLocalAddressGenerationMode = "stable-privacy";
            IPv6PrivacyExtensions = "yes";
          };
        })
        (lib.mkIf cfg.cloudflare.dns.enable {
          dhcpV4Config.UseDNS = false;
          ipv6AcceptRAConfig.UseDNS = false;
        })
      ];
    };
  };
}

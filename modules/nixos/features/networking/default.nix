{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.networking;
in
{
  imports = [ ./cloudflare.nix ];

  options.features.networking = {
    enable = lib.mkEnableOption "NetworkManager networking.";
    privacyIPv6.enable = lib.mkEnableOption "IPv6 privacy extensions.";
    vpn.enable = lib.mkEnableOption "NetworkManager VPN plugins.";
    primaryInterface = lib.mkOption {
      type = lib.types.str;
      description = "The primary networking interface for operations.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      plugins = lib.mkIf cfg.vpn.enable (
        with pkgs;
        [
          networkmanager-openvpn
          networkmanager-openconnect
        ]
      );
      dns = lib.mkIf cfg.cloudflare.dns.enable "systemd-resolved";
      settings.connection = lib.mkMerge [
        (lib.mkIf cfg.privacyIPv6.enable {
          "ipv6.ip6-privacy" = 2;
          "ipv6.addr-gen-mode" = 1;
        })
        (lib.mkIf cfg.cloudflare.dns.enable {
          "ipv4.ignore-auto-dns" = true;
          "ipv6.ignore-auto-dns" = true;
        })
      ];
    };
  };
}

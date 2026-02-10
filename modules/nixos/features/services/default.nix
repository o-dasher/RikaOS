{ lib, ... }:
with lib;
{
  imports = [
    ./bluetooth.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./openrgb.nix
    ./tailscale.nix
    ./sddm.nix
  ];

  options.features.services = {
    bluetooth.enable = mkEnableOption "bluetooth";
    flatpak.enable = mkEnableOption "Flatpak support";
    gnome-keyring.enable = mkEnableOption "gnome keyring";
    openrgb.enable = mkEnableOption "openrgb";
    tailscale = {
      enable = mkEnableOption "tailscale";
      dnsFirewall = {
        enable = mkEnableOption "Allow DNS (53/tcp+udp) on tailscale0";
      };
      dnsServer = {
        enable = mkEnableOption "CoreDNS on tailscale with host list";
        zone = mkOption {
          type = types.str;
          default = "dshs.cc";
          description = "DNS zone CoreDNS will serve on tailscale";
        };
        tailnetIP = mkOption {
          type = types.str;
          description = "Tailscale IP to bind and return for hosts";
        };
        hosts = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Hostnames to resolve to tailnetIP in the zone";
        };
        forwarders = mkOption {
          type = types.listOf types.str;
          default = [ "1.1.1.1" "1.0.0.1" ];
          description = "Upstream resolvers for other queries in the zone";
        };
      };
    };
    sddm = {
      enable = mkEnableOption "SDDM Display Manager";
      background = mkOption {
        type = types.path;
        description = "Background image for SDDM";
      };
      flavor = mkOption {
        type = types.str;
        description = "Catppuccin flavor for SDDM (e.g., mocha, latte)";
      };
      accent = mkOption {
        type = types.str;
        description = "Catppuccin accent color for SDDM (e.g., mauve, pink)";
      };
    };
    enable = mkEnableOption "service features" // {
      default = true;
    };
  };
}

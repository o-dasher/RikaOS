{ lib, ... }:
with lib;
{
  imports = [
    ./bluetooth.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./openrgb.nix
    ./tailscale.nix
    ./transmission.nix
    ./sddm.nix
  ];

  options.features.services = {
    bluetooth.enable = mkEnableOption "bluetooth";
    flatpak.enable = mkEnableOption "Flatpak support";
    gnome-keyring.enable = mkEnableOption "gnome keyring";
    openrgb.enable = mkEnableOption "openrgb";
    prowlarr.customIndexer = {
      enable = mkEnableOption "custom Prowlarr indexer definition";
      url = mkOption {
        type = types.str;
        description = "URL to the custom Prowlarr indexer YAML definition";
      };
      filename = mkOption {
        type = types.str;
        default = "custom-indexer.yml";
        description = "Filename to save in Prowlarr Definitions/Custom";
      };
    };
    tailscale = {
      enable = mkEnableOption "tailscale";
      dns.server = {
        enable = mkEnableOption "CoreDNS on tailscale with host list";
        zone = mkOption {
          type = types.str;
          description = "DNS zone CoreDNS will serve on tailscale";
        };
        tailnetIP = mkOption {
          type = types.str;
          description = "Tailscale IP to bind and return for hosts";
        };
        hosts = mkOption {
          type = types.listOf types.str;
          description = "Hostnames to resolve to tailnetIP in the zone";
          default = [ ];
        };
        forwarders = mkOption {
          type = types.listOf types.str;
          description = "Upstream resolvers for other queries in the zone";
          default = [
            "1.1.1.1"
            "1.0.0.1"
          ];
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

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  cfg,
  RikaOS-private,
  ...
}:
let
  inherit (cfg) targetHostName state;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Modules
  userPreferences.enable = true;
  nixSetup = {
    enable = true;
    trusted-users = [ cfg.profiles.nue ];
  };

  features = {
    networking = {
      enable = true;
      networkManager.enable = false;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  security.polkit.enable = true;
  networking = {
    hostName = targetHostName;
    useDHCP = false;
    firewall =
      let
        minecraftPorts = [
          60926
          60927
        ];
      in
      {
        enable = true;
        allowedTCPPorts = minecraftPorts;
        allowedUDPPorts = minecraftPorts;
      };
  };

  systemd.network = {
    enable = true;
    networks."10-main" =
      let
        inherit (RikaOS-private.gensokyo) ipv6prefix;
      in
      {
        matchConfig.Name = "enp1s0";
        address = [
          "192.168.0.67/24"
          "${ipv6prefix}::8/64"
        ];

        ipv6Prefixes = [
          { Prefix = "${ipv6prefix}::/64"; }
        ];

        networkConfig = {
          DHCP = "yes";
          IPv6SendRA = true;
        };

        routes = [
          { Gateway = "fe80::"; }
          { Gateway = "192.168.0.1"; }
        ];
      };
  };

  users.users.${cfg.profiles.nue} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  system.stateVersion = state;
}

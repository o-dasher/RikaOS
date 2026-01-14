{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  options.gensokyo.networking.ipv6prefix = lib.mkOption {
    type = lib.types.str;
    default = "SECRET";
    description = "IPv6 prefix for the main network interface";
  };

  config = {
    features.core.userPreferences.enable = true;
    features = {
      nix = {
        enable = true;
        nixpkgs.enable = true;
      };
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
      useDHCP = false;
      firewall =
        let
          minecraftPorts = [
            60926
            60927
          ];
        in
        {
          allowedTCPPorts = minecraftPorts;
          allowedUDPPorts = minecraftPorts;
        };
    };

    systemd.network = {
      enable = true;
      networks."10-main" = {
        matchConfig.Name = "enp1s0";
        address = [
          "192.168.0.67/24"
          "${config.gensokyo.networking.ipv6prefix}::8/64"
        ];

        ipv6Prefixes = [
          { Prefix = "${config.gensokyo.networking.ipv6prefix}::/64"; }
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

    users.users.thiago = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

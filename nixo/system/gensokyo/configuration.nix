# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  ...
}:
let
  inherit (cfg) hostName state;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "Brazil/East";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "br-abnt2";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;
  networking = {
    inherit hostName;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        60926
        60927
      ];
      allowedUDPPorts = [
        60926
        60927
      ];
    };
  };

  systemd.network.enable = true;
  systemd.network.networks."10-main" =
    let
      ipv6prefix = "";
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

  users.users.${cfg.profiles.nue} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      git
      openjdk
      tmux
    ];
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  hardware.graphics.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        cfg.profiles.nue
      ];
    };
    gc = {
      automatic = true;
      options = "-d";
    };
    optimise.automatic = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = state;
}

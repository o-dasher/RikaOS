# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  ...
}:
let
  inherit (cfg) hostName username state;
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

  users.users.${username} = {
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
        username
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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = state; # Did you read the comment?
}

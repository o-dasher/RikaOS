# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  config,
  inputs,
  ...
}:
let
  inherit (cfg) hostName username state;

  # Some localy stuff
  locale = "en_US.UTF-8";
  timezone = "Brazil/East";

  # Keymapping
  keymap = "br-abnt2";
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    inputs.playit-nixos-module.nixosModules.default
  ];

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

  sops = {
    defaultSopsFile = ../../secrets/store/homeserver.yaml;
    age = {
      sshKeyPaths = [ "$HOME/.ssh/id_ed25519" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      ipv6prefix = { };
      playit_secret = { };
    };
  };

  environment.variables = {
    IPV6PREFIX = "$(cat ${config.sops.secrets.ipv6prefix.path})";
  };

  systemd.network.enable = true;
  systemd.network.networks."lan" =
    let
      ipv6prefix = builtins.getEnv "IPV6PREFIX";
    in
    {
      matchConfig.Name = "enp1s0";
      address = [
        "192.168.0.67/24"
        "${ipv6prefix}::8/64"
      ];

      ipv6Prefixes = [
        { ipv6PrefixConfig.Prefix = "${ipv6prefix}::/64"; }
      ];

      networkConfig = {
        IPv6SendRA = true;
      };

      routes = [
        { Gateway = "fe80::10"; }
        { Gateway = "192.168.0.1"; }
      ];
    };

  time.timeZone = timezone;

  i18n.defaultLocale = locale;
  console = {
    font = "Lat2-Terminus16";
    keyMap = keymap;
  };

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.libvirtd.members = [ username ];
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
      udev
      tmux
    ];
  };

  programs = {
    virt-manager.enable = true;
    light.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  hardware = {
    graphics.enable = true;
  };

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

  services.playit = {
    enable = true;
    user = "playit";
    group = "playit";
    secretPath = config.sops.secrets.playit_secret.path;
  };

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

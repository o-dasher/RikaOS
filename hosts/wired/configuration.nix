{
  pkgs,
  ...
}:
let
  # Public/VPS interface.
  externalInterface = "ens3";
  slskPort = 2234;
  wg = {
    interface = "wg0";
    port = 51820;

    # WireGuard private addresses for VPS <-> home tunnel.
    vpsIPv4 = "10.72.0.1";
    homeIPv4 = "10.72.0.2";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/vda";
  features = {
    boot.kernel.enable = true;
    services.tailscale = {
      enable = true;
      trust = true;
      dns.server = {
        enable = true;
        zone = "dshs.cc";
        tailnetIP = "fd7a:115c:a1e0::d101:3990";
        hosts = [ "netbird.dshs.cc" ];
      };
    };
  };

  networking = {
    wg-quick.interfaces.${wg.interface} = {
      address = [ "${wg.vpsIPv4}/24" ];
      privateKeyFile = "/var/lib/wireguard/${wg.interface}.key";
      generatePrivateKeyFile = true;
      listenPort = wg.port;
      peers = [
        {
          publicKey = "adsVEuj+sihaXKsoymSbCEC8dkYeecAP96lZPGCQJl4=";
          allowedIPs = [ "${wg.homeIPv4}/32" ];
        }
      ];
    };

    nat = {
      enable = true;
      externalInterface = externalInterface;
      internalInterfaces = [ wg.interface ];
      forwardPorts = [
        {
          sourcePort = slskPort;
          destination = "${wg.homeIPv4}:${toString slskPort}";
        }
      ];
    };

    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [ wg.port ];
      allowedTCPPorts = [ slskPort ];
    };
  };

  services = {
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts."netbird.dshs.cc".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:51830
      '';
    };
    fail2ban = {
      enable = true;
      bantime = "24h";
    };
    netbird.clients.netbird = {
      port = 51830;
      interface = "nb-wired";
      hardened = false;
    };
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  users.users.lain = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
    ];
  };

  programs.fish.enable = true;
}

{
  pkgs,
  ...
}:
let
  wg = {
    interface = "wg0";
    port = 51820;
    forwarders = [
      {
        ip = "10.72.0.2";
        tcp = [ 2234 ];
        publicKey = "adsVEuj+sihaXKsoymSbCEC8dkYeecAP96lZPGCQJl4=";
      }
    ];
  };

  normalizedForwarders = map (
    forwarder:
    forwarder
    // {
      tcp = forwarder.tcp or [ ];
      udp = forwarder.udp or [ ];
    }
  ) wg.forwarders;
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
        hosts = [ ];
      };
    };
  };

  networking = {
    wg-quick.interfaces.${wg.interface} = {
      address = [ "10.72.0.1/24" ];
      privateKeyFile = "/var/lib/wireguard/${wg.interface}.key";
      generatePrivateKeyFile = true;
      listenPort = wg.port;
      peers = map (forwarder: {
        publicKey = forwarder.publicKey;
        allowedIPs = [ "${forwarder.ip}/32" ];
      }) wg.forwarders;
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ wg.interface ];
      forwardPorts = builtins.concatMap (
        {
          ip,
          tcp,
          udp,
          ...
        }:
        let
          forwardToDestination =
            proto: ports:
            map (port: {
              inherit proto;
              sourcePort = port;
              destination = "${ip}:${toString port}";
            }) ports;
        in
        (forwardToDestination "tcp" tcp) ++ (forwardToDestination "udp" udp)
      ) normalizedForwarders;
    };

    firewall = {
      allowedUDPPorts = [ wg.port ] ++ builtins.concatMap (forwarder: forwarder.udp) normalizedForwarders;
      allowedTCPPorts = builtins.concatMap (forwarder: forwarder.tcp) normalizedForwarders;
    };
  };

  services = {
    fail2ban = {
      enable = true;
      bantime = "24h";
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

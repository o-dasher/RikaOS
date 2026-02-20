{
  pkgs,
  config,
  lib,
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

  headscaleDomain = "wired.dshs.cc";
  headscaleURI = "https://${headscaleDomain}";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  features = {
    boot.kernel.enable = true;
    networking = {
      enable = true;
      primaryInterface = "ens3";
      ddns = {
        enable = true;
        updateIPv4 = true;
        useWebIPv6 = false;
        zone = "dshs.cc";
        domains = [ headscaleDomain ];
      };
    };
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

  boot = {
    kernel.sysctl."net.ipv6.conf.all.forwarding" = 0;
    loader.grub.device = "/dev/vda";
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
    headscale = {
      enable = true;
      address = "127.0.0.1";
      settings = {
        server_url = headscaleURI;
        dns = {
          magic_dns = true;
          base_domain = "wired.local";
          nameservers.global = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };
    };
    headplane = lib.mkIf (config.age.secrets ? headscale-pre-auth-key) {
      enable = true;
      settings = {
        integration = {
          proc.enabled = false;
          agent.pre_authkey_path = config.age.secrets.headscale-pre-auth-key.path;
        };
        server = {
          host = "127.0.0.1";
          cookie_secure = true;
          cookie_secret_path = config.age.secrets.headscale-cookie-secret.path;
        };
        headscale = {
          url = headscaleURI;
          config_path = config.services.headscale.configFile;
          config_strict = false;
        };
      };
    };
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts.${headscaleDomain}.extraConfig = ''
        handle /admin* {
          reverse_proxy 127.0.0.1:${toString config.services.headplane.settings.server.port}
        }

        reverse_proxy 127.0.0.1:${toString config.services.headscale.port}
      '';
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

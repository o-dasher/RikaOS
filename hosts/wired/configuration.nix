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

  # Headscale
  headscaleDomain = "wired.dshs.cc";
  headscaleURI = "https://${headscaleDomain}";

  # OIDC provider settings for Headscale/Headplane.
  keycloakDomain = "auth.dshs.cc";
  oidcIssuer = "https://${keycloakDomain}/realms/headscale";
  oidcClientId = "headscale";
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
        domains = [
          headscaleDomain
          keycloakDomain
        ];
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

  age.secrets = lib.mkIf config.rika.utils.hasSecrets (
    lib.genAttrs
      [
        "headscale-pre-auth-key"
        "headscale-cookie-secret"
        "headscale-oidc-client-secret"
        "headplane-oidc-api-key"
      ]
      (_: {
        owner = "headscale";
        group = "headscale";
      })
  );

  services = {
    fail2ban = {
      enable = true;
      bantime = "24h";
    };
    keycloak = lib.mkIf config.rika.utils.hasSecrets {
      enable = true;
      database.passwordFile = config.age.secrets.keycloak-db-password.path;
      settings = {
        http-enabled = true;
        http-host = "127.0.0.1";
        http-port = 8081;
        proxy-headers = "xforwarded";
        hostname = keycloakDomain;
      };
    };
    headscale = lib.mkIf config.rika.utils.hasSecrets {
      enable = true;
      address = "127.0.0.1";
      settings = {
        server_url = headscaleURI;
        policy.mode = "database";
        dns = {
          magic_dns = true;
          base_domain = "wired.local";
          search_domains = [ ];
          override_local_dns = false;
          extra_records = [ ];
          nameservers = {
            split = { };
            global = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
        };
        oidc = {
          issuer = oidcIssuer;
          client_id = oidcClientId;
          client_secret_path = config.age.secrets.headscale-oidc-client-secret.path;
          scope = [
            "openid"
            "profile"
            "email"
          ];
        };
      };
    };
    headplane = lib.mkIf config.rika.utils.hasSecrets {
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
        oidc = {
          issuer = oidcIssuer;
          client_id = oidcClientId;
          client_secret_path = config.age.secrets.headscale-oidc-client-secret.path;
          headscale_api_key_path = config.age.secrets.headplane-oidc-api-key.path;
          redirect_uri = "${headscaleURI}/admin/oidc/callback";
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
      virtualHosts = {
        ${headscaleDomain}.extraConfig = ''
          handle /admin* {
            reverse_proxy 127.0.0.1:${toString config.services.headplane.settings.server.port}
          }

          reverse_proxy 127.0.0.1:${toString config.services.headscale.port}
        '';
        ${keycloakDomain}.extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.keycloak.settings.http-port}
        '';
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

{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Headscale
  headscaleDomain = "wired.dshs.cc";
  headscaleURI = "https://${headscaleDomain}";

  # OIDC provider settings for Headscale/Headplane.
  keycloakDomain = "auth.dshs.cc";
  oidcIssuer = "https://${keycloakDomain}/realms/headscale";
  oidcClientId = "headscale";

  # Wireguard
  wg = {
    interface = "wg0";
    port = 51820;
    forwarders = [
      {
        ip = "10.72.0.2";
        tcp = [ 2234 ];
        publicKey = "adsVEuj+sihaXKsoymSbCEC8dkYeecAP96lZPGCQJl4=";
      }
      {
        ip = "10.72.0.3";
        tcp = [ 2235 ];
        publicKey = "Z2lLQ1rQ/GWwX4Y44SRkwrbppwr2LMDTkgQjISXM0jU=";
      }
    ];
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  profiles.secureServer.enable = true;
  features = {
    boot.kernel.enable = true;
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
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
      cloudflare = {
        warp.enable = true;
        dns.enable = true;
      };
    };
    services.tailscale = {
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

  networking =
    let
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
      wg-quick.interfaces.${wg.interface} = lib.mkIf config.rika.utils.hasSecrets {
        address = [ "10.72.0.1/24" ];
        privateKeyFile = config.age.secrets.wireguard-wired-private-key.path;
        listenPort = wg.port;
        peers = map (
          { publicKey, ip, ... }:
          {
            inherit publicKey;
            allowedIPs = [ "${ip}/32" ];
          }
        ) wg.forwarders;
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
              map (sourcePort: {
                inherit proto sourcePort;
                destination = "${ip}:${toString sourcePort}";
              }) ports;
          in
          (forwardToDestination "tcp" tcp) ++ (forwardToDestination "udp" udp)
        ) normalizedForwarders;
      };

      firewall = {
        allowedUDPPorts = [ wg.port ] ++ builtins.concatMap ({ udp, ... }: udp) normalizedForwarders;
        allowedTCPPorts = builtins.concatMap ({ tcp, ... }: tcp) normalizedForwarders;
      };
    };

  age.secrets =
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
      });

  services = lib.mkMerge [
    {
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
    }
    (lib.mkIf config.rika.utils.hasSecrets {
      keycloak = {
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
      headscale = {
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
      headplane = {
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
    })
  ];

  users.users.lain = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys =
      let
        inherit (config.features.services.openssh.keys) rika;
      in
      [ rika ];
  };

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

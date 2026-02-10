{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems = {
    "/mnt/media-hdd" = {
      device = "/dev/disk/by-uuid/749d870c-a88c-4c37-82ea-a9807c24cfea";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/shared/Media" = {
      device = "/shared/.media-local:/mnt/media-hdd";
      fsType = "fuse.mergerfs";
      depends = [ "/mnt/media-hdd" ];
      options = [
        "defaults"
        "allow_other"
        "use_ino"
        "cache.files=partial"
        "category.create=mfs"
      ];
    };
  };

  environment.systemPackages = [ pkgs.mergerfs ];

  features.core.userPreferences.enable = true;
  features = {
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
    boot = {
      kernel.enable = true;
      limine.enable = true;
    };
    filesystem.sharedFolders = {
      enable = true;
      rootFolders.shared.Media = [ ];
      folders.shared.Media = [
        "Music"
        "Movies"
        "Series"
        "Anime"
        "Books"
      ];
    };
    networking = {
      enable = true;
      cloudflare.dns.enable = true;
      privacyIPv6.enable = true;
      primaryInterface = "enp1s0";
      ddns = {
        enable = true;
        updateIPv4 = false;
        useWebIPv6 = false;
        zone = "dshs.cc";
        domains = [
          "fuio.dshs.cc"
          "files.dshs.cc"
          "jellyfin.dshs.cc"
          "jellyseerr.dshs.cc"
        ];
      };
    };
    services.tailscale = {
      enable = true;
      dnsFirewall.enable = true;
      dnsServer = {
        enable = true;
        zone = "dshs.cc";
        tailnetIP = "fd7a:115c:a1e0::9801:8d41";
        hosts = [
          "sonarr.dshs.cc"
          "radarr.dshs.cc"
        ];
      };
    };
  };

  systemd.services.sftpgo.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "3s";
  };

  security.polkit.enable = true;
  services = {
    jellyfin.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    jellyseerr.enable = true;
    qbittorrent = {
      enable = true;
      webuiPort = 8086;
    };
    fail2ban = {
      enable = true;
      bantime = "24h";
    };
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    playit = {
      enable = true;
      secretPath = config.age.secrets.playit-secret.path;
    };
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.survival = {
        enable = true;
        autoStart = true;
        enableReload = true;
        package = pkgs.paperServers.paper-1_21_11;
        jvmOpts = "-Xms3G -Xmx6G -Djava.net.preferIPv6Addresses=true -Djava.net.preferIPv4Stack=false";

        serverProperties = {
          server-ip = "::";
          server-port = 6967;
          motd = "Gensokyo Survival";
          max-players = 16;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = false;
          spawn-protection = 0;
          view-distance = 16;
          simulation-distance = 16;
        };

        symlinks =
          let
            sources = pkgs.callPackage ../../_sources/generated.nix { };
            plugins = {
              "Geyser-Spigot.jar" = sources.geyser-spigot.src;
              "Floodgate-Spigot.jar" = sources.floodgate-spigot.src;
              "ViaVersion.jar" = sources.viaversion.src;
              "AuthMe.jar" = sources.authme.src;
              "SkinsRestorer.jar" = sources.skinsrestorer.src;
            };
          in
          pkgs.lib.mapAttrs' (name: value: pkgs.lib.nameValuePair "plugins/${name}" value) plugins
          // {
            "plugins/floodgate/floodgate-sqlite-database.jar" = sources.floodgate-sqlite-database.src;
          };

        files = {
          "plugins/Geyser-Spigot/config.yml".value.java.auth-type = "floodgate";
          "plugins/AuthMe/config.yml".value.settings.restrictions.allowedNicknameCharacters =
            "[a-zA-Z0-9_\\.]*";
          "plugins/floodgate/config.yml".value.player-link = {
            enable-own-linking = true;
            use-global-linking = false;
            type = "sqlite";
          };
        };
      };
    };
    sftpgo = {
      enable = true;
      extraReadWriteDirs = [ "/shared/Media" ];
      settings = {
        sftpd.bindings = [
          {
            address = "";
            port = 2022;
          }
        ];
        httpd.bindings = [
          {
            port = 8080;
            address = "127.0.0.1";
            enable_web_admin = true;
            enable_web_client = true;
          }
        ];
      };
    };
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts = {
        "files.dshs.cc".extraConfig = ''
          reverse_proxy 127.0.0.1:8080
          request_body {
            max_size 32GB
          }
        '';
        "jellyfin.dshs.cc".extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        "jellyseerr.dshs.cc".extraConfig = ''
          reverse_proxy 127.0.0.1:5055
        '';
        "sonarr.dshs.cc".extraConfig = ''
          reverse_proxy 127.0.0.1:8989
        '';
        "radarr.dshs.cc".extraConfig = ''
          reverse_proxy 127.0.0.1:7878
        '';
      };
    };
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      2022
    ];
  };

  users = {
    groups.users.members = [
      "sftpgo"
      "jellyfin"
      "sonarr"
      "radarr"
      "qbittorrent"
    ];

    users.thiago = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
      ];
      extraGroups = [
        "wheel"
      ];
    };
  };

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

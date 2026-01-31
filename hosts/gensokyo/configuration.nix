{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  features.core.userPreferences.enable = true;
  features = {
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
    filesystem.sharedFolders = {
      enable = true;
      rootFolderNames = [
        "/shared"
        "/shared/Media"
      ];
      folderNames = [
        "/shared/Media/Music"
        "/shared/Media/Movies"
        "/shared/Media/Series"
        "/shared/Media/Anime"
      ];
    };
    networking = {
      enable = true;
      cloudflare.dns.enable = true;
      stableIPv6 = {
        enable = true;
        matchInterface = "enp1s0";
      };
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  security.polkit.enable = true;
  services = {
    fail2ban = {
      enable = true;
      bantime = "24h";
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      extraConfig = ''
        Match User media
          ChrootDirectory /shared/Media
          ForceCommand internal-sftp
          AllowTcpForwarding no
          X11Forwarding no
      '';
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

    jellyfin.enable = true;
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts."jellyfin.dshs.cc" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "noreply@dshs.cc";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.users = {
    jellyfin.extraGroups = [ "users" ];
    media = {
      isNormalUser = true;
      home = "/shared/Media";
      createHome = false;
      group = "users";
      shell = "${pkgs.shadow}/bin/nologin";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUXecCb1MBsd4myMzHfRiN5AIbhub61wffasXzWyM8k fifahomem@archlinux-fodao"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
      ];
    };
    thiago = {
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

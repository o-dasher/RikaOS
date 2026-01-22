{
  pkgs,
  config,
  ...
}:
let
  bedrockPort = 16967;
in
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
  networking.firewall.allowedUDPPorts = [ bedrockPort ];
  networking.firewall.allowedTCPPorts = [ bedrockPort ];
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

        files."plugins/Geyser-Spigot/config.yml".value = {
          java.auth-type = "floodgate";
          bedrock = {
            address = config.features.networking.stableIPv6.ipv6;
            port = bedrockPort;
          };
        };

        files."plugins/floodgate/config.yml".value = {
          player-link = {
            enable-own-linking = true;
            use-global-linking = false;
            type = "sqlite";
          };
        };

        files."plugins/AuthMe/config.yml" = {
          value = {
            settings.restrictions.allowedNicknameCharacters = "[a-zA-Z0-9_\\.]*";
          };
        };
      };
    };
  };

  users.users.thiago = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
    ];
    extraGroups = [
      "wheel"
    ];
  };

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

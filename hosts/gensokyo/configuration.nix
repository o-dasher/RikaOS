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
    networking = {
      enable = true;
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
        jvmOpts = "-Xms2G -Xmx4G -Djava.net.preferIPv6Addresses=true -Djava.net.preferIPv4Stack=false";

        serverProperties = {
          server-ip = "::";
          motd = "Gensokyo Survival";
          max-players = 8;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = false;
          spawn-protection = 0;
          view-distance = 16;
          simulation-distance = 16;
        };

        symlinks = {
          "plugins/Geyser-Spigot.jar" = pkgs.fetchurl {
            url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-Rv8BmljZ5AHiG9OcQMG9UwAsi4V5xsS0WdSuFFaQPuw=";
          };
          "plugins/Floodgate-Spigot.jar" = pkgs.fetchurl {
            url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-1kevbNh1zsZbJj/+TlEgTabptu24tIHTe6/czILxBdk=";
          };
        };

        files."plugins/Geyser-Spigot/config.yml" = {
          value = {
            java.auth-type = "floodgate";
            bedrock.clone-remote-port = true;
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

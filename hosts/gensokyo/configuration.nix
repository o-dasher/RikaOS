{
  pkgs,
  ...
}:
let
  javaPort = 6967;
  bedrockPort = 6769;
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
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.survival = {
        enable = true;
        autoStart = true;
        enableReload = true;
        package = pkgs.paperServers.paper-1_21_11;
        jvmOpts = "-Xms2G -Xmx4G";

        serverProperties = {
          server-port = javaPort;
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
            hash = "sha256-1v1yj1b19bnlb6sc9ikrhn5jq02kpp0l176k3gi03r6rb2d03zs6";
          };
          "plugins/Floodgate-Spigot.jar" = pkgs.fetchurl {
            url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-1n85y61crp5ggg9q3d5qxnvfk9jd418lxziz4rdwdkkmv1nayiyn";
          };
        };

        files."plugins/Geyser-Spigot/config.yml" = {
          value = {
            bedrock = {
              address = "0.0.0.0";
              port = bedrockPort;
              motd1 = "Gensokyo";
              motd2 = "Minecraft Server";
            };
            remote = {
              address = "127.0.0.1";
              port = javaPort;
              auth-type = "floodgate";
            };
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

{
  pkgs,
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
  networking.firewall.allowedUDPPorts = [ 19132 ];
  services = {
    services.fail2ban = {
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
        package = pkgs.paperServers.paper-1_21_4;
        jvmOpts = "-Xms2G -Xmx4G";

        serverProperties = {
          server-port = 25565;
          motd = "Gensokyo Minecraft Server";
          max-players = 10;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = true;
          spawn-protection = 0;
          view-distance = 12;
          simulation-distance = 10;
        };

        symlinks = {
          plugins = pkgs.linkFarmFromDrvs "plugins" (
            builtins.attrValues {
              Geyser = pkgs.fetchurl {
                url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot";
                hash = "sha256-YbhG+b6NGL487yMRQvAt8gdNylvjrGeF0e9ffC5OR40=";
                name = "Geyser-Spigot.jar";
              };
              Floodgate = pkgs.fetchurl {
                url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot";
                hash = "sha256-1kevbNh1zsZbJj/+TlEgTabptu24tIHTe6/czILxBdk=";
                name = "Floodgate-Spigot.jar";
              };
              AutoReloader = pkgs.fetchurl {
                url = "https://github.com/notTamion/AutoReloader/releases/download/v1.0.1/AutoReloader-1.0.1.jar";
                hash = "sha256-EV7os5smIld9/mvQfCNj2QF+IEMSIwMRGBAjPzN50p4=";
              };
            }
          );
        };

        files."plugins/Geyser-Spigot/config.yml" = {
          value = {
            bedrock = {
              address = "0.0.0.0";
              port = 19132;
              motd1 = "Gensokyo";
              motd2 = "Minecraft Server";
            };
            remote = {
              address = "127.0.0.1";
              port = 25565;
              auth-type = "floodgate";
            };
          };
        };
      };
    };
  };

  users.users.thiago = {
    isNormalUser = true;
    openssh.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
    ];
    extraGroups = [
      "wheel"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}

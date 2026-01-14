# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = "enp6s0";
      ipv6AcceptRAConfig.Token = "stable";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
    };
  };

  time.hardwareClockInLocalTime = true;
  services = {
    printing.enable = true;
    openssh.enable = true;
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
    };
  };

  theme.lain.enable = true;
  features = {
    core.userPreferences.enable = true;
    graphics.enable = true;
    hardware.amdgpu.enable = true;
    hardware.keyboard.enable = true;
    gaming.enable = true;
    audio.enable = true;
    virtualization.enable = true;
    networking.enable = true;
    desktop.hyprland.enable = true;
    boot = {
      enable = true;
      cachy.enable = true;
    };
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
    services = {
      bluetooth.enable = true;
      flatpak.enable = true;
      openrgb.enable = true;
      playit.enable = true;
      gnome-keyring.enable = true;
      thunar.enable = true;
      sddm = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        background = ../../assets/Wallpapers/lain.jpg;
      };
    };
    security.secureBoot = {
      enable = true;
      encryptionUnlock.enable = true;
    };
    filesystem = {
      steamLibrary = {
        enable = true;
        users = [
          "rika"
          "satoko"
        ];
      };
      sharedFolders.folderNames = [
        "/shared/Games"
        "/shared/Media"
        "/shared/Media/Torrent"
      ];
      bitlocker = lib.mkIf (config.age.secrets ? bitlocker-hinamizawa-shared) {
        enable = true;
        drives.windows-shared = {
          device = "/dev/disk/by-uuid/0cd42b48-325f-4851-8e4d-fc9ed4a4e08d";
          keyFile = config.age.secrets.bitlocker-hinamizawa-shared.path;
        };
      };
    };
  };

  boot = {
    # Disk encryption
    initrd.luks.devices."luks-36bb58a5-3907-4ecc-99b8-3133907e4ab3".device =
      "/dev/disk/by-uuid/36bb58a5-3907-4ecc-99b8-3133907e4ab3";

    # BUG: I use bitlocker. I need to wait for: https://codeberg.org/Limine/Limine/issues/12
    # loader.limine.extraEntries = ''
    #   /Windows 11
    #     protocol: efi
    #     path: guid(a4b6a0ac-5aee-457c-8854-26cd6375d45f):/EFI/Microsoft/Boot/bootmgfw.efi
    # '';
  };

  fileSystems =
    let
      btrfsOpts = [
        "compress=zstd:1"
        "noatime"
      ];
    in
    {
      "/".options = btrfsOpts;
      "/home".options = btrfsOpts;
    };

  users = {
    groups.libvirtd.members = [
      "rika"
      "satoko"
    ];
    users = {
      rika = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "dialout" # Serial devices (zmk)
          "video"
          "render"
          "adbusers"
          "gamemode"
        ];
      };
      satoko = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "video"
          "render"
          "gamemode"
        ];
      };
    };
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    steam.gamescopeSession.args = [
      "-w 1920"
      "-h 1080"
      "-r 240"
      "--fullscreen"
      "--force-grab-cursor"
      "--rt"
    ];
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

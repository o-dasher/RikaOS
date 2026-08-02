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

  time.hardwareClockInLocalTime = true;

  profiles.desktop.enable = true;

  features = {
    desktop.theme.lain.enable = true;
    hardware.amdgpu.enable = true;
    networking = {
      enable = true;
      privacyIPv6.enable = true;
      primaryInterface = "enp6s0";
      cloudflare = {
        warp.enable = true;
        dns.enable = true;
      };
    };
    boot.kernel.enable = true;
    boot.limine.secure = {
      enable = true;
      encryptionUnlock.enable = true;
    };
    nix.nixpkgs.enable = true;
    services = {
      openssh.enable = true;
      bluetooth.enable = true;
      openrgb.enable = true;
      gnome-keyring.enable = true;
      sunshine.enable = true;
      transmission = {
        enable = true;
        openPeerPorts = true;
        openRPCPort = false;
      };
      sddm = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        background = ../../assets/Wallpapers/lain.jpg;
      };
    };
    filesystem = {
      steamLibrary = {
        enable = true;
        users = [
          "rika"
          "satoko"
        ];
      };
      sharedFolders = {
        enable = true;
        folders.shared.Games = [ ];
      };
      bitlocker = lib.mkIf config.rika.utils.hasSecrets {
        enable = true;
        defaultKeyFile = config.age.secrets.bitlocker-hinamizawa-shared.path;
        drives = {
          windows-shared.device = "/dev/disk/by-uuid/0cd42b48-325f-4851-8e4d-fc9ed4a4e08d";
          windows-shared-plus.device = "/dev/disk/by-uuid/3abcc218-fe8c-4539-afb5-cc94357813aa";
        };
      };
    };
  };

  boot = {
    # Disk encryption
    initrd.luks.devices."luks-36bb58a5-3907-4ecc-99b8-3133907e4ab3".device =
      "/dev/disk/by-uuid/36bb58a5-3907-4ecc-99b8-3133907e4ab3";

    loader.limine.extraEntries = ''
      /Windows 11
        protocol: efi_boot_entry
        entry: Windows Boot Manager
    '';
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
    groups.users.members = [ "transmission" ];
    users =
      let
        commonGroups = [
          "video"
          "dialout"
          "input"
          "render"
          "libvirtd"
          "gamemode"
        ];
      in
      {
        rika = {
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = [
            "wheel"
            "adbusers"
            "transmission"
            "podman"
          ]
          ++ commonGroups;
          openssh.authorizedKeys.keys =
            let
              inherit (config.features.services.openssh.keys) rika;
            in
            [ rika ];
        };
        satoko = {
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = commonGroups;
        };
      };
  };

  networking = {
    interfaces.${config.features.networking.primaryInterface}.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };

    firewall =
      let
        stardewValleyPort = 24642;
      in
      {
        checkReversePath = "loose";
        allowedUDPPorts = [ stardewValleyPort ];
      };
  };

  fonts.enableDefaultPackages = true;
  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
    steam.gamescopeSession.args = [
      "-w 1920"
      "-h 1080"
      "-r 240"
      "--fullscreen"
      "--force-grab-cursor"
      "--rt"
      "--expose-wayland"
    ];
  };
}

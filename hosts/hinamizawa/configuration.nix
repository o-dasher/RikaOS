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
  services = {
    gvfs.enable = true;
    printing.enable = true;
    openssh.enable = true;
    transmission = {
      enable = true;
      openFirewall = true;
      package = pkgs.transmission_4;
    };
  };

  theme.lain.enable = true;
  features = {
    core.userPreferences.enable = true;
    graphics.enable = true;
    hardware.amdgpu.enable = true;
    hardware.keyboard.enable = true;
    gaming = {
      enable = true;
      suppressNotifications.enable = true;
    };
    audio.enable = true;
    virtualization.enable = true;
    networking = {
      enable = true;
      cloudflare = {
        warp.enable = true;
        dns.enable = true;
      };
      stableIPv6 = {
        enable = true;
        matchInterface = "enp6s0";
      };
    };
    boot = {
      enable = true;
      secure = {
        enable = true;
        encryptionUnlock.enable = true;
      };
    };
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
    services = {
      bluetooth.enable = true;
      flatpak.enable = true;
      openrgb.enable = true;
      gnome-keyring.enable = true;
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
        rootFolderNames = [ "/shared/Media" ];
        folderNames = [
          "/shared/Games"
          "/shared/Media/Torrent"
        ];
      };
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
    # Virtual webcam for phone camera via scrcpy
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="Phone Camera" exclusive_caps=1
    '';

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

  users.users =
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
        ]
        ++ commonGroups;
      };
      satoko = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = commonGroups;
      };
    };

  networking.firewall =
    let
      stardewValleyPort = 24642;
      nicotineSoulseekPort = 2234;
    in
    {
      allowedUDPPorts = [ stardewValleyPort ];
      allowedTCPPorts = [ nicotineSoulseekPort ];
    };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    hyprland.enable = true;
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

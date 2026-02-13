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
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  features = {
    audio.enable = true;
    virtualization.enable = true;
    graphics.enable = true;
    gaming.enable = true;
    desktop.theme.lain.enable = true;
    core.userPreferences.enable = true;
    hardware = {
      amdgpu.enable = true;
      keyboard.enable = true;
    };
    networking = {
      enable = true;
      privacyIPv6.enable = true;
      cloudflare = {
        warp.enable = true;
        dns.enable = true;
      };
    };
    boot = {
      kernel.enable = true;
      limine = {
        enable = true;
        secure = {
          enable = true;
          encryptionUnlock.enable = true;
        };
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
      tailscale.enable = true;
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
      bitlocker = lib.mkIf (config.age.secrets ? bitlocker-hinamizawa-shared) {
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
      transmission.extraGroups = [ "users" ];
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
      ];
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
      };
      satoko = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = commonGroups;
      };
    };

  networking = {
    firewall =
      let
        stardewValleyPort = 24642;
        nicotineSoulseekPort = 2234;
      in
      {
        checkReversePath = "loose";
        allowedUDPPorts = [ stardewValleyPort ];
        allowedTCPPorts = [ nicotineSoulseekPort ];
      };

    wg-quick.interfaces.wg-nicotine = {
      address = [ "10.72.0.2/24" ];
      generatePrivateKeyFile = true;
      privateKeyFile = "/var/lib/wireguard/wg-nicotine.key";
      table = "off";
      peers = [
        {
          publicKey = "d1QgawQP+arz1fgRnAqmuSRrAWfc+FHyDIaN3Yuf0io=";
          endpoint = "wired.dshs.cc:51820";
          allowedIPs = [ "0.0.0.0/0" ];
        }
      ];
    };
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    hyprland.enable = true;
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
    ];
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}

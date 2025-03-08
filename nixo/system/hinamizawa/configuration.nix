# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  ghostty,
  inputs,
  ...
}:
let
  inherit (cfg) targetHostName state;
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Modules
  userPreferences.enable = true;
  secureBoot.enable = true;
  sharedFolders.folderNames = [
    "/steam-games"
    "/shared/Games"
  ];
  nixSetup = {
    enable = true;
    trusted-users = [ cfg.profiles.rika ];
  };

  boot = {
    # Setup ntfs
    supportedFilesystems.ntfs = true;
    # Disk encryption
    initrd.luks.devices."luks-36bb58a5-3907-4ecc-99b8-3133907e4ab3".device =
      "/dev/disk/by-uuid/36bb58a5-3907-4ecc-99b8-3133907e4ab3";
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
      "/windows-shared" = {
        device = "/dev/disk/by-uuid/2CDA3C8EDA3C55F4";
        fsType = "ntfs";
      };
    };

  # Nix caching
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  # Gaming and gpu stuff
  nixpkgs.config.allowUnfree = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    # Reference for multi user installation
    # https://github.com/ValveSoftware/Proton/issues/4820#issuecomment-2569535495
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  # Audio setup
  security.rtkit.enable = true; # make pipewire realtime-capable
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    lowLatency.enable = true;
  };

  security.polkit.enable = true;
  networking = {
    hostName = targetHostName;
    networkmanager.enable = true;
  };

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable gnome keyring to store password and stuff?
    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };

    # Thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    # Display manager
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm.enable = true;

    # Rgb controller
    hardware.openrgb.enable = true;

    # Keyboard
    udev.packages = with pkgs; [ vial ];
  };

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/windows-highcontrast.yaml";
    targets = {
      gnome.enable = true;
    };
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.libvirtd.members = [ cfg.profiles.rika ];
    users = {
      ${cfg.profiles.rika} = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "video"
          "adbusers"
          "gamemode"
        ];
      };
      ${cfg.profiles.satoko} = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "video"
          "gamemode"
        ];
      };
    };
  };

  programs = {
    virt-manager.enable = true;
    hyprland.enable = true;
    adb.enable = true;
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-volman ];
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  environment.systemPackages = [
    ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = state; # Did you read the comment?
}

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  ...
}:
let
  inherit (cfg) state;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  userPreferences.enable = true;
  secureBoot.enable = true;

  nixSetup = {
    enable = true;
    trusted-users = [
      cfg.profiles.rika
    ];
  };

  multiUserFiles = {
    sharedFolders.folderNames = [
      "/shared/Games"
    ];
    shared-steam-library = {
      enable = true;
      users = [ cfg.profiles.rika ];
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  };

  services = {
    printing.enable = true;
    openssh.enable = true;
    displayManager.gdm.enable = true;
  };

  features = {
    graphics.enable = true;
    hardware.amdgpu.enable = true;
    hardware.keyboard.enable = true;

    gaming.enable = true;
    audio.enable = true;
    virtualization.enable = true;
    desktop.hyprland.enable = true;
    services = {
      bluetooth.enable = true;
      openrgb.enable = true;
      playit.enable = true;
      gnome-keyring.enable = true;
      thunar.enable = true;
    };
    networking.enable = true;
    boot.enable = true;
  };

  boot = {
    # Disk encryption
    initrd.luks.devices."luks-36bb58a5-3907-4ecc-99b8-3133907e4ab3".device =
      "/dev/disk/by-uuid/36bb58a5-3907-4ecc-99b8-3133907e4ab3";

    loader.systemd-boot.windows = {
      "nvme0n1p1" = {
        title = "Windows 11";
        efiDeviceHandle = "HD1B";
        sortKey = "a_windows";
      };
    };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.libvirtd.members = [ cfg.profiles.rika ];
    users = {
      ${cfg.profiles.rika} = {
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
    };
  };

  programs = {
    adb.enable = true;
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

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

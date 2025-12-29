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

  userPreferences.enable = true;
  secureBoot = {
    enable = true;
    encryptionUnlock.enable = true;
  };

  nixSetup = {
    enable = true;
    nixpkgs.enable = true;
  };

  multiUserFiles = {
    sharedFolders.folderNames = [
      "/shared/Games"
      "/shared/Media"
    ];
    shared-steam-library = {
      enable = true;
      users = [
        cfg.profiles.rika
        cfg.profiles.satoko
      ];
    };
  };

  theme.cirnold.enable = true;

  services = {
    printing.enable = true;
    openssh.enable = true;
    displayManager.gdm.enable = true;
  };

  programs.steam.gamescopeSession.args = [
    "-W 1920"
    "-H 1080"
    "-r 240"
    "--fullscreen"
  ];

  features = {
    graphics.enable = true;
    hardware.amdgpu.enable = true;
    hardware.keyboard.enable = true;
    gaming.enable = true;
    audio.enable = true;
    virtualization.enable = true;
    networking.enable = true;
    desktop.hyprland.enable = true;
    services = {
      bluetooth.enable = true;
      openrgb.enable = true;
      playit.enable = true;
      gnome-keyring.enable = true;
      thunar.enable = true;
    };
    boot = {
      enable = true;
      cachy.enable = true;
    };
  };

  boot = {
    # Disk encryption
    initrd.luks.devices."luks-36bb58a5-3907-4ecc-99b8-3133907e4ab3".device =
      "/dev/disk/by-uuid/36bb58a5-3907-4ecc-99b8-3133907e4ab3";

    loader.limine.extraEntries = ''
      /Windows 11
        protocol: efi
        path: guid(a4b6a0ac-5aee-457c-8854-26cd6375d45f):/EFI/Microsoft/Boot/bootmgfw.efi
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
      ${cfg.profiles.satoko} = {
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

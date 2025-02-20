# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  cfg,
  lib,
  inputs,
  ...
}:
let
  inherit (cfg) hostName username state;
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
  ];

  time.timeZone = "Brazil/East";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "br-abnt2";

  nixpkgs.config.allowUnfree = true;

  # Audio setup
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader.systemd-boot = {
      enable = lib.mkForce false;
      consoleMode = "max";
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable gnome keyring to store password and stuff?
    gnome.gnome-keyring.enable = true;

    # Thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    # Bluetooth
    blueman.enable = true;

    # Display manager
    displayManager = {
      sddm = {
        enable = true;
        theme = "catppuccin-sddm-corners";
        wayland = {
          enable = true;
          compositor = "kwin";
        };
      };
    };

    # Rgb controller
    hardware.openrgb.enable = true;

    # Keyboard
    udev.packages = with pkgs; [ vial ];
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
  users.groups.libvirtd.members = [ username ];
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "adbusers"
    ]; # Enable ‘sudo’ for the user.
  };

  environment = {
    systemPackages = with pkgs; [
      sbctl # Secure boot
      catppuccin-sddm-corners
      git
      kwin
    ];
  };

  programs = {
    virt-manager.enable = true;
    adb.enable = true;
    light.enable = true;
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-volman ];
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        username
      ];
    };
    gc = {
      automatic = true;
      options = "-d";
    };
    optimise.automatic = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

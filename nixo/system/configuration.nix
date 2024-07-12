# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, config, ... }:
let
  inherit (config.rika) hostName username state;

  # Some localy stuff
  locale = "en_US.UTF-8";
  timezone = "Brazil/East";

  # Keymapping
  keymap = "br-abnt2";
in
{
  imports = [
    # Include the results of the hardware scan.
    ../config/setconfig.nix
    ./hardware-configuration.nix
  ];

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
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  security.polkit.enable = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  time.timeZone = timezone;

  i18n.defaultLocale = locale;
  console = {
    font = "Lat2-Terminus16";
    keyMap = keymap;
    # useXkbConfig = true; # I am using wayland...
  };

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable gnome keyring to store password and stuff?
    gnome.gnome-keyring.enable = true;

    blueman.enable = true;
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

    udev.packages = with pkgs; [ vial ];
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
    ]; # Enable ‘sudo’ for the user.
  };

  environment = {
    systemPackages = with pkgs; [
      catppuccin-sddm-corners
      kwin
    ];
  };

  programs = {
    light.enable = true;
    fish.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    sway = {
      enable = true;
      extraPackages = [ ];
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

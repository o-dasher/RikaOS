# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ inputs, pkgs, ... }:
let
	inherit (import ./variables.nix) state timezone hostname locale keymap;
	inherit (import ../home-manager/variables.nix) username;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./audio.nix
	  inputs.catppuccin.nixosModules.catppuccin
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
	systemd-boot.enable = true;
	efi.canTouchEfiVariables = true;
  };

  networking = {
	  hostName = hostname;
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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment = {
	  sessionVariables = {
		XDG_CONFIG_HOME = "\${HOME}/.config";
	  };

	  # This should be kept to a minimal. Don't ask me why, I think it is better this way.
	  systemPackages = with pkgs; [
		cargo
		gcc
		tmux
		wget
		hyfetch
		killall
	  ];
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  nix.settings.experimental-features = ["flakes"];

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
  system.stateVersion = "${state}"; # Did you read the comment?
}


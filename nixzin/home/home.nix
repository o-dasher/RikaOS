{ inputs, pkgs, ... }:
let
	inherit (import ../common/variables.nix) username state;
in
{
  imports = [
	./theme
	./alacritty
	./fish
	./waybar
	./wofi
	./sway
	inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  home = {
	username = username;
	homeDirectory = "/home/${username}";
	stateVersion = state;
	packages = with pkgs; [
		# System utils
		xdg-terminal-exec
		pamixer

		# General
		firefox
		discord
		mpv

		# Programming
		rustup
		github-cli
		git

		# Desktop
		wofi
		waybar
		swww
		inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
		wl-clipboard
		xfce.thunar
		pavucontrol
		whitesur-icon-theme

		# fonts
		jetbrains-mono
		# Disk space is not cheap okay?
		(nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })  
	  ];
  };

  nix = {
	  gc = {
		  automatic = true;
		  frequency = "daily";
		  options = "--delete-older-than 1d";
	  };
  };

  services.mako = {
	  enable = true;
	  defaultTimeout = 4000;
	  output = "HDMI-A-1";
	  anchor = "top-right";
  };

  programs = {
	home-manager.enable = true;
  };
}

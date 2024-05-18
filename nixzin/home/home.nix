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
	./swaync
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
		qbittorrent
		obs-studio
		mpv

		# Programming
		rustup
		github-cli
		ripgrep
		git

		# Desktop
		wofi
		waybar
		swww
		grimblast
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

  xdg.portal = {
	  enable = true;
	  extraPortals = [pkgs.xdg-desktop-portal-wlr];
  };

  nix = {
	  gc = {
		  automatic = true;
		  frequency = "daily";
		  options = "--delete-older-than 1d";
	  };
  };

  programs = {
	home-manager.enable = true;
  };
}

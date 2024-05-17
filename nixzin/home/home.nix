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
		xfce.thunar

		# Programming
		rustup
		github-cli
		git

		# Desktop
		wofi
		waybar
		swww

		# Screenshoot 
		grim
		slurp
		wl-clipboard

		# fonts
		jetbrains-mono
		# Disk space is not cheap okay?
		(nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })  
	  ];
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

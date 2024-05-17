{pkgs, lib, ...}:
let
	inherit (lib) toUpper stringLength substring;

	capital = s : toUpper (substring 0 1 s) + (substring 1 (stringLength s) s);
	c = {
		flavour = "mocha";
		accent = "pink";
	};
in
{
	xdg.enable = true;
	catppuccin = c;
	gtk = {
		enable = true;
		theme = {
			name = "Catppuccin-${capital c.flavour}-Standard-Pink-Dark";
			package = pkgs.catppuccin-gtk.override {
			  accents = [c.accent];
			  size = "standard";
			  tweaks = [];
			  variant = c.flavour;
			};
		};
		iconTheme = {
			name = "WhiteSur";
			package = pkgs.whitesur-icon-theme;
		};
  };
}

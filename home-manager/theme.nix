{pkgs, ...}:
{
	gtk = {
		enable = true;
		iconTheme = {
			package = pkgs.whitesur-icon-theme;
			name = "WhiteSur-Dark";
		};
		theme = {
			package = pkgs.whitesur-gtk-theme;
			name = "WhiteSur-Dark";
		};
	};
}

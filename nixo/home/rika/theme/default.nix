{ pkgs, ... }:
{
  stylix = {
	autoEnable = false;

	targets = {
		tmux.enable = true;
		firefox.enable = true;
		fish.enable = true;
		lazygit.enable = true;
		wezterm.enable = true;
		sway.enable = true;
		waybar.enable = true;
	};

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    polarity = "dark";
    targets = {
      vim.enable = false;
    };
    opacity =
      let
        v = 0.9;
      in
      {
        popups = v;
        desktop = v;
        terminal = v;
      };
  };
}

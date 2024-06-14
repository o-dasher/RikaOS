{ pkgs, ... }:
{
  stylix = {
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    targets = {
      tmux.enable = true;
      firefox.enable = true;
      fish.enable = true;
      lazygit.enable = true;
      wezterm.enable = true;
      sway.enable = true;
      waybar.enable = true;
      vim.enable = true;
    };

    polarity = "dark";
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

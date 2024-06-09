{ pkgs, ... }:
{
  stylix = {
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
  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}

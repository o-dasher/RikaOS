{ pkgs, ... }:
{
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
    opacity =
      let
        v = 0.9;
      in
      {
        popups = v;
        terminal = v;
      };
  };
}

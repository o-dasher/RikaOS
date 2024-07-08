{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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

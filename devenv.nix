{ pkgs, ... }:
{
  packages = with pkgs; [
    stylua
    nixfmt-rfc-style
  ];

  languages = {
    nix.enable = true;
    lua.enable = true;
  };
}

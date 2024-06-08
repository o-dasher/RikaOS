{ pkgs, ... }:
{
  packages = with pkgs; [
    git
    nixd
    stylua
    nixfmt-rfc-style
  ];

  languages = {
    nix.enable = true;
    lua.enable = true;
  };
}

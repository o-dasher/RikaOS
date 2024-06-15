{ pkgs, ... }:
{
  packages = with pkgs; [
    stylua
    nixfmt-rfc-style
    prettierd
  ];

  languages = {
    nix.enable = true;
    lua.enable = true;
  };
}

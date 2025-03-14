{
  ...
}:
{
  imports = [
    ../../shared.nix
    ./theme
  ];

  nixpkgs.config.allowUnfree = true;
  neovim.enable = true;
  terminal.enable = true;

  programs.home-manager.enable = true;
}

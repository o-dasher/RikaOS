{ lib, ... }:
{
  imports = [
    ./jetbrains.nix
    ./neovim.nix
  ];

  options.features.editors = {
    enable = lib.mkEnableOption "code editors and development environments (Neovim and JetBrains)" // {
      default = true;
    };
  };
}

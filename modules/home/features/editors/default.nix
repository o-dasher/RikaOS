{ lib, ... }:
{
  imports = [
    ./jetbrains.nix
    ./neovim.nix
  ];

  options.features.editors.enable = lib.mkEnableOption "editor features" // {
    default = true;
  };
}

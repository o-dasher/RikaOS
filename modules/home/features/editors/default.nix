{ lib, ... }:
with lib;
{
  imports = [
    ./neovim.nix
    ./jetbrains.nix
  ];

  options.features.editors = {
    enable = mkEnableOption "editor features" // {
      default = true;
    };
  };
}

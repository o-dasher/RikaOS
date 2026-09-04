{ lib, ... }:
{
  imports = [
    ./jetbrains.nix
    ./neovim.nix
  ];

  options.features.editors = {
    enable = lib.mkEnableOption "Editor features." // {
      default = true;
    };
  };
}

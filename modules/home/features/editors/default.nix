{ lib, ... }:
{
  imports = [
    ./jetbrains.nix
    ./neovim.nix
    ./zed.nix
  ];

  options.features.editors.enable = lib.mkEnableOption "Editor features." // {
    default = true;
  };
}

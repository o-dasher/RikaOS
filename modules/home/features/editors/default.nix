{ lib, ... }:
with lib;
{
  imports = [
    ./neovim.nix
    ./jetbrains.nix
  ];

  options.features.editors = {
    enable = mkEnableOption "editor features";
    neovim = {
      enable = mkEnableOption "neovim";
      neovide.enable = mkEnableOption "neovide";
    };
    jetbrains = {
      enable = mkEnableOption "JetBrains IDEs configuration";
      android-studio.enable = mkEnableOption "Android Studio";
      datagrip.enable = mkEnableOption "DataGrip";
      rider.enable = mkEnableOption "Rider";
    };
  };
}

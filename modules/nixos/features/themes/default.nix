{ lib, config, ... }:
{
  imports = [
    ./cirnold.nix
    ./graduation.nix
  ];
  config = lib.mkIf (config.theme.cirnold.enable || config.theme.graduation.enable) {
    stylix = {
      enable = true;
      polarity = "dark";
      # nixcord module is available in HM, but not always in system.
      # Targets might be different between HM and NixOS.
      # Generally safe defaults here.
    };
  };
}

{ lib, ... }:
with lib;
{
  imports = [
    ./development.nix
    ./utilities.nix
    ./gaming.nix
    ./generic-linux.nix
    ./multimedia.nix
    ./social.nix
    ./browser.nix
    ./security.nix
  ];

  options.profiles = {
    development.enable = mkEnableOption "Development profile";
    utilities.enable = mkEnableOption "Utilities profile";
    gaming.enable = mkEnableOption "Gaming profile";
    multimedia.enable = mkEnableOption "multimedia profile";
    social.enable = mkEnableOption "social profile";
    browser.enable = mkEnableOption "browser profile";
    security.enable = mkEnableOption "security profile";
  };
}

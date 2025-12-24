{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.profiles.browser = {
    enable = lib.mkEnableOption "browser profile";
  };

  config = lib.mkIf config.profiles.browser.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
    ];
  };
}

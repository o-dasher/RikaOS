{ pkgs, lib, config, inputs, ... }:
{
  options.suites.browser = {
    enable = lib.mkEnableOption "browser suite";
  };

  config = lib.mkIf config.suites.browser.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
    ];
  };
}

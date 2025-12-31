{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.profiles.browser = {
    enable = lib.mkEnableOption "browser profile";
  };

  config = lib.mkIf config.profiles.browser.enable {
    programs.zen-browser = {
      enable = true;
      profiles.default.extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
        ];
    };
  };
}

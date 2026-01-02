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
    package = lib.mkOption {
      type = lib.types.unspecified;
      description = "browser package";
    };
  };

  config = lib.mkIf config.profiles.browser.enable {
    profiles.browser.package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    programs.zen-browser = {
      enable = true;
      profiles.default.extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          bitwarden
        ];
    };
  };
}

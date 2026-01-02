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
    profiles.browser.package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
    programs.zen-browser = {
      enable = true;
      package = config.profiles.browser.package;
      policies = {
        AutofillAddressEnabled = true;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.default.extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          bitwarden
        ];
    };
  };
}
